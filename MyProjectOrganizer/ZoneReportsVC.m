//
//  ZoneReportsVC.m
//  LocationReport
//
//  Created by Mark Deraeve on 19/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ZoneReportsVC.h"
#import "AUZone.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageThumbView.h"
#import "AddPropertyVC.h"
#import "PropertyCell.h"
#import "TemplateChooser.h"

@interface ZoneReportsVC ()
@property (strong, nonatomic) UIImage * img;
@property (weak, nonatomic) IBOutlet ADBannerView *_UIiAD;
@end

@implementation ZoneReportsVC
{
    VariableStore * store;
    NSMutableArray * picturesForZone;
    ALAssetsLibrary* assetslibrary;
    NSArray * subZonesArray;
    NSDate * selectedDate;
    bool isBrowse;
    NSArray * propertiesForZone;
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
    [VariableStore sharedInstance].selectedSubZone=nil;
    [super viewDidAppear:animated];
    [self loadData];
}

-(void) loadData
{
    [self GetPicturesForZone];
    [self GetSubZonesForZone];
    [self GetProperties];
}

-(void) FillProjectInfo
{
    if (store.selectedProject != nil && store.selectedZone != nil)
    {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        self.lblProjectDate.text = [formatter stringFromDate:[VariableStore sharedInstance].selectedProject.proj_date];
        NSString * proj_title;
        if (store.selectedProject.proj_title.length > 20)
        {
            proj_title = [store.selectedProject.proj_title substringToIndex:20];
        }
        else
        {
            proj_title = store.selectedProject.proj_title;
        }
        self.lblProjectTitle.text = [NSString stringWithFormat:@"%@ -> %@",proj_title, store.selectedZone.z_title ];
        self.lblProjectDescription.text = [VariableStore sharedInstance].selectedZone.z_info;
    }
}
- (IBAction)btnNewSubZone:(id)sender
{
    store.selectedSubZone = nil;
    store.selectedSubZoneTemplate=nil;
    //First check if the template type is not type
    if(store.creatingTemplate==NO && [store.selectedProject.proj_templateType isEqual: kTemplateType])
    {
        //Set the selectedZoneTemplate to the selected template.
        
        NSArray * templates = [DBStore GetAllSubZones:store.selectedZone.z_templateUsed_id];
        if (templates.count > 0 && [VariableStore sharedInstance].creatingTemplate==NO)
        {
            if (chooser==nil)
            {
                chooser = [[TemplateChooser alloc] init];
            }
            chooser.szTemplates = templates;
            [chooser ShowTemplateChooser:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"NewSubZone" sender:self];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"NewSubZone" sender:self];
    }

}

#pragma mark Properties

-(void) GetProperties
{
    if ([store.selectedZone.prop_id intValue]>0)
    {
        propertiesForZone = [DBStore GetAllPropertiesForID:store.selectedZone.prop_id];
    }
    else
    {
        propertiesForZone = nil;
    }
    [self.colProperties reloadData];
}

- (IBAction)btnAddProperty:(id)sender
{
    AddPropertyVC* addPropVC = [[AddPropertyVC alloc] initWithNibName:@"AddPropertyVC"  bundle:nil];
    addPropVC.propID = store.selectedZone.prop_id;
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
    //reload the collection view
    if ([store.selectedZone.prop_id intValue] <= 0)
    {
        store.selectedZone.prop_id = prop.prop_id;
        [DBStore SaveContext];
    }

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

#pragma mark SubZones

-(void) GetSubZonesForZone
{
    if (store.selectedProject!=nil)
    {
        subZonesArray=nil;
        [self getSubZonesArray];
        [self.colSubReports reloadData];
    }
}

-(NSArray *) getSubZonesArray
{
    if (subZonesArray==nil)
    {
        subZonesArray = [DBStore GetAllSubZones:store.selectedZone.z_id];
    }
    return subZonesArray;
}


#pragma mark Pictures

-(void) GetPicturesForZone
{
    if (store.selectedZone.pic_id && [store.selectedZone.pic_id intValue] > 0)
    {
        picturesForZone = [NSMutableArray arrayWithArray:[DBStore GetPicturesID:store.selectedZone.pic_id]];
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
    
    if (!store.selectedZone.pic_id || [store.selectedZone.pic_id intValue] == 0)
    {
        AUPicture * pic = [DBStore CreatePictureWithURL:url AndComment:@"" AndPictureID:nil];
        store.selectedZone.pic_id = pic.pic_id;
    }
    else
    {
        [DBStore CreatePictureWithURL:url AndComment:@"" AndPictureID:store.selectedZone.pic_id];
    }
    [DBStore SaveContext];
    [self GetPicturesForZone];
}

-(void) PictureDeleted
{
    [self GetPicturesForZone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.colSubReports)
    {
        return [self getSubZonesArray].count;
    }
    else if (collectionView == self.colPictures)
    {
        return picturesForZone.count;
    }
    else
    {
        return propertiesForZone.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.colSubReports)
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
    if (collectionView==self.colSubReports)
    {
        SubZonesCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubZoneCell" forIndexPath:indexPath];
        AUSubZone * sz = [[self getSubZonesArray] objectAtIndex:indexPath.row];
        cell.lblTitle.text = sz.sz_title;
        cell.lblInfo.text = sz.sz_info;
        return cell;
    }
    else if (collectionView == self.colPictures)
    {
        typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
        typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
        
        
        ImageThumbView  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        AUPicture * p = [picturesForZone objectAtIndex:indexPath.row];
        
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
        AUProperty * prop = [propertiesForZone objectAtIndex:indexPath.row];
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
        
        AUPicture * p = [picturesForZone objectAtIndex:indexPath.row];
        
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
    else if(collectionView==self.colSubReports)
    {
        AUSubZone * selectedSubZone = [subZonesArray objectAtIndex:indexPath.row];
        store.selectedSubZone = selectedSubZone;
        [self performSegueWithIdentifier:@"EditSubZone" sender:self];
    }
    else if (collectionView == self.colProperties)
    {
        AUProperty * prop = [propertiesForZone objectAtIndex:indexPath.row];
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

- (void) viewWillDisappear:(BOOL)animated {
    [self._UIiAD removeFromSuperview];
    //this._UIiAD.delegate = nil;
    self._UIiAD = nil;
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
