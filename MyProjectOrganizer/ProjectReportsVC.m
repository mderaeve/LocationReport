//
//  ProjectReportsVC.m
//  LocationReport
//
//  Created by Mark Deraeve on 11/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ProjectReportsVC.h"
#import "AUProject.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageThumbView.h"
#import "AddPropertyVC.h"
#import "PropertyCell.h"
#import "TemplateChooser.h"


@interface ProjectReportsVC ()
@property (strong, nonatomic) UIImage * img;
@end

@implementation ProjectReportsVC
{
    VariableStore * store;
    NSMutableArray * picturesForProject;
    ALAssetsLibrary* assetslibrary;
    NSArray * zonesArray;
    NSDate * selectedDate;
    bool isBrowse;
    NSArray * propertiesForProject;
    TemplateChooser * chooser;
}

@synthesize popoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    assetslibrary = [[ALAssetsLibrary alloc] init];

    // Do any additional setup after loading the view.
    store = [VariableStore sharedInstance];
    [self FillProjectInfo];
}

-(void)viewDidAppear:(BOOL)animated
{
    store.selectedZone=nil;
    [super viewDidAppear:animated];
    [self loadData];
}

-(void) loadData
{
    [self GetPicturesForProject];
    [self GetZonesForProject];
    [self GetProperties];
}

-(void) FillProjectInfo
{
    if (store.selectedProject != nil)
    {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        self.lblProjectDate.text = [formatter stringFromDate:store.selectedProject.proj_date];
        self.lblProjectTitle.text = store.selectedProject.proj_title;
        self.lblProjectDescription.text = store.selectedProject.proj_info;
    }
}

#pragma mark Zones

-(void) GetZonesForProject
{
    if (store.selectedProject!=nil)
    {
        zonesArray=nil;
        [self getZonesArray];
        [self.colReports reloadData];
    }
}

-(NSArray *) getZonesArray
{
    if (zonesArray==nil)
    {
        zonesArray = [DBStore GetAllZones:store.selectedProject.proj_id];
    }
    return zonesArray;
}

- (IBAction)btnNewZone:(id)sender
{
    store.selectedZone = nil;
    store.selectedZoneTemplate=nil;
    //First check if the template type is not type
    if(store.creatingTemplate==NO && [store.selectedProject.proj_templateType isEqual: kTemplateType])
    {
        //Set the selectedZoneTemplate to the selected template.
        NSArray * templates = [DBStore GetAllZones:store.selectedProject.proj_templateUsed_id];
        if (templates.count > 0 && [VariableStore sharedInstance].creatingTemplate==NO)
        {
            if (chooser==nil)
            {
                chooser = [[TemplateChooser alloc] init];
            }
            chooser.zTemplates = templates;
            [chooser ShowTemplateChooser:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"NewZone" sender:self];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"NewZone" sender:self];
    }
}

#pragma mark Pictures

-(void) GetPicturesForProject
{
    if (store.selectedProject.pic_id && [store.selectedProject.pic_id intValue] > 0)
    {
        picturesForProject = [NSMutableArray arrayWithArray:[DBStore GetPicturesID:store.selectedProject.pic_id]];
    }
    [self.colPictures reloadData];
}

#pragma mark pictures taking

- (IBAction)btnTakePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        imagePicker.modalInPopover=YES;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        isBrowse = NO;
    }
    else
    {
        [self BrowsePictures];
    }
    
}

- (IBAction)btnBrowsePicture:(id)sender
{
    [self BrowsePictures];
}

-(void)BrowsePictures
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    self.popoverController = [[UIPopoverController alloc]
                              initWithContentViewController:imagePicker];
    
    self.popoverController.delegate = self;
    [self.popoverController setPopoverContentSize:CGSizeMake(500, 500)];
    
    
    UIView *tempView = self.view;
    CGPoint point = CGPointMake(tempView.frame.size.width/2,
                                tempView.frame.size.height/2);
    CGSize size = CGSizeMake(100, 100);
    [self.popoverController presentPopoverFromRect:
     CGRectMake(point.x, point.y, size.width, size.height)
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    isBrowse=YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info
                      objectForKey:UIImagePickerControllerOriginalImage];
    if (isBrowse==NO)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        //ALAssetsLibrary *library = [Utils defaultAssetsLibrary];
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             [self SavePictureIDforURL:[NSString stringWithFormat:@"%@", assetURL]];
             
         }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSString * url = @"";
        url = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        [self SavePictureIDforURL:url];
        
        [self.popoverController dismissPopoverAnimated:true];
        isBrowse=NO;
    }
}

-(void) SavePictureIDforURL:(NSString *) url
{
    
    if (!store.selectedProject.pic_id || [store.selectedProject.pic_id intValue] == 0)
    {
        AUPicture * pic = [DBStore CreatePictureWithURL:url AndComment:@"" AndPictureID:nil];
        store.selectedProject.pic_id = pic.pic_id;
    }
    else
    {
        [DBStore CreatePictureWithURL:url AndComment:@"" AndPictureID:store.selectedProject.pic_id];
    }
    [DBStore SaveContext];
    [self GetPicturesForProject];
}

-(void) PictureDeleted
{
    [self GetPicturesForProject];
}

#pragma mark Properties

-(void) GetProperties
{
    if ([store.selectedProject.prop_id intValue]>0)
    {
        propertiesForProject = [DBStore GetAllPropertiesForID:store.selectedProject.prop_id];
    }
    else
    {
        propertiesForProject = nil;
    }
    [self.colProperties reloadData];
}

- (IBAction)btnAddProperty:(id)sender
{
    AddPropertyVC* addPropVC = [[AddPropertyVC alloc] initWithNibName:@"AddPropertyVC"  bundle:nil];
    addPropVC.propID = store.selectedProject.prop_id;
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:addPropVC];
    self.popoverController.popoverContentSize = CGSizeMake(store.propPopUpWidth, store.propPopUpHeight); //or whatever size you need
    addPropVC.delegate = self;
    //this will present the view controller from the sender's frame, assuming this code is used inside an IBAction
    //and the popover's arrow will point down
    [self.popoverController presentPopoverFromRect:[sender frame] inView:self.vwProperties  permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

}

-(void) PropertyAdded:(AUProperty *) prop
{
    [self.popoverController dismissPopoverAnimated:YES];
    if ([store.selectedProject.prop_id intValue] <= 0)
    {
        store.selectedProject.prop_id = prop.prop_id;
        [DBStore SaveContext];
    }

    //reload the collection view
    [self GetProperties];
}

-(void) PropertyChanged
{
    [self.popoverController dismissPopoverAnimated:YES];
    //reload the collection view
    [self GetProperties];
}

-(void) PropertyDeleted
{
    [self GetProperties];
}

- (IBAction)EditProperties:(id)sender
{
    //Segue to edit Xib
}

#pragma CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.colReports)
    {
        return [self getZonesArray].count;
    }
    else if (collectionView == self.colPictures)
    {
        return picturesForProject.count;
    }
    else
    {
        return propertiesForProject.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.colReports)
    {
        return CGSizeMake(174.0, 136.0);
    }
    else if (collectionView == self.colPictures)
    {
        return CGSizeMake(174.0, 151.0);
    }
    else
    {
        return CGSizeMake(174.0, 136.0);
    }
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.colReports)
    {
        ZoneCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZoneCell" forIndexPath:indexPath];
        AUZone * zone = [[self getZonesArray] objectAtIndex:indexPath.row];
        cell.lblTitle.text = zone.z_title;
        cell.lblInfo.text = zone.z_info;
        return cell;
    }
    else if (collectionView == self.colPictures)
    {
        typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
        typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
        
        
        ImageThumbView  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        AUPicture * p = [picturesForProject objectAtIndex:indexPath.row];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            //ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [myasset thumbnail];//[rep fullResolutionImage];
            UIImage *im;
            if (iref)
            {
                @try {
                    //im = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
                    im = [UIImage imageWithCGImage:iref];
                    [cell.imgImage setImage:im];
                }
                @catch (NSException *exception) {
                    NSLog(@"Exception:%@",exception);
                    [cell.imgImage setImage:[UIImage imageNamed:@"error.png"]];
                }
            }
            else
            {
                [cell.imgImage setImage:[UIImage imageNamed:@"error.png"]];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"can't get image");
        };
        NSURL *asseturl = [NSURL URLWithString:p.pic_url];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
        //[GeneralFunctions MakeSimpleRoundView:cell];
        cell.delegate = self;
        cell.pic = p;
        return cell;
    }
    else
    {
        PropertyCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PropertyCell" forIndexPath:indexPath];
        AUProperty * prop = [propertiesForProject objectAtIndex:indexPath.row];
        cell.lblProperty.text = [store Translate: prop.prop_type];
        cell.lblTitle.text = prop.prop_title;
        cell.lblValue.text = prop.prop_value;
        cell.prop   = prop;
        cell.delegate = self;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*if(collectionView==self.colReports)
    {
        Zone * selectedZone = [zonesArray objectAtIndex:indexPath.row];
        store.selectedZone = selectedZone;
        [self performSegueWithIdentifier:@"EditZone" sender:self];
    }*/
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==self.colPictures)
    {
        ImageThumbView * cell = (ImageThumbView *)[collectionView cellForItemAtIndexPath:indexPath];
        typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
        typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
        
        AUPicture * p = [picturesForProject objectAtIndex:indexPath.row];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            
            if (iref)
            {
                @try {
                    self.img = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
                    [StoryBoardNavigation NavigateToChangePictureStoryboard:self AndPicture:self.img AndPictureObject:cell.pic];
                }
                @catch (NSException *exception) {
                    NSLog(@"Exception:%@",exception);
                    [cell.imgImage setImage:[UIImage imageNamed:@"error.png"]];
                }
            }
            else
            {
                [cell.imgImage setImage:[UIImage imageNamed:@"error.png"]];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"can't get image");
        };
        NSURL *asseturl = [NSURL URLWithString:p.pic_url];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    else if(collectionView==self.colReports)
    {
        AUZone * selectedZone = [zonesArray objectAtIndex:indexPath.row];
        store.selectedZone = selectedZone;
        [self performSegueWithIdentifier:@"EditZone" sender:self];
    }
    else if (collectionView == self.colProperties)
    {
        AUProperty * prop = [propertiesForProject objectAtIndex:indexPath.row];
        //popup the property
        AddPropertyVC* addPropVC = [[AddPropertyVC alloc] initWithNibName:@"AddPropertyVC"  bundle:nil];
        addPropVC.property = prop;
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:addPropVC];
        
        self.popoverController.popoverContentSize = CGSizeMake(store.propPopUpWidth, store.propPopUpHeight); //or whatever size you need
        addPropVC.delegate = self;
        //this will present the view controller from the sender's frame, assuming this code is used inside an IBAction
        //and the popover's arrow will point down
        [self.popoverController presentPopoverFromRect:[collectionView frame] inView:self.vwProperties  permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
