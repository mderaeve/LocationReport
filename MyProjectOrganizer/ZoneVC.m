//
//  ZoneVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 15/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ZoneVC.h"
#import "AUZone.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageThumbView.h"
#import "PropertyHeader.h"
#import "TemplateFactory.h"

@interface ZoneVC ()
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ZoneVC
{
    bool isBrowse;
    VariableStore * store;
    long nrsections;
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
    // Do any additional setup after loading the view.
    store = [VariableStore sharedInstance];
    
    if (store.selectedZone != nil)
    {
        [self setTitle:store.selectedZone.z_title];
    }
    else if (store.selectedZoneTemplate !=nil)
    {
        self.txtDescription.text = store.selectedZoneTemplate.z_info;
    }
    else
    {
        [self setTitle:[[VariableStore sharedInstance] Translate:@"$PO$NewZone"]];
    }
    // Do any additional setup after loading the view.
    [self initVars];
    [self refresh];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GetProperties];
}

-(void) initVars
{
    isBrowse=NO;
}

-(void) refresh
{
    self.vwDetails.hidden=YES;
    if (store.selectedZone)
    {
        self.txtProjectTitle.text = store.selectedProject.proj_title;
        self.txtTitle.text = store.selectedZone.z_title;
        self.txtDescription.text = store.selectedZone.z_info;
        //self.vwDetails.hidden=NO;

    }
    else
    {
        self.txtProjectTitle.text = store.selectedProject.proj_title;
        //self.vwDetails.hidden=YES;
    }
}

#pragma mark Properties

-(void) GetProperties
{
    NSError *error;
    //sorteren volgens type
    if (store.selectedProject.prop_id>0)
    {
        self.fetchedResultsController = [DBStore GetAllPropertiesGroupedByType:store.selectedZone.prop_id];
        if (![self.fetchedResultsController performFetch:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        nrsections = [[self.fetchedResultsController sections] count];
        
        [self.colProperties reloadData];
    }
}

-(void) PropertyDeleted
{
    [self GetProperties];
}


#pragma CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
    return count;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSInteger count = [sectionInfo numberOfObjects];
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(700, 156.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        PropertyHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PropertyHeader" forIndexPath:indexPath];
        //NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
        
        
        headerView.lblTitle.text = [sectionInfo name];
        
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.colProperties)
    {
        PropertyCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PropertyCell" forIndexPath:indexPath];
        
        AUProperty *prop = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.lblTitle.text = prop.prop_title;
        cell.lblValue.text = prop.prop_value;
        cell.lblProperty.text = prop.prop_type;
        cell.delegate = self;
        cell.prop   = prop;
        return cell;
    }
    else
    {
        return nil;
    }
}

- (IBAction)btnSaveZone:(id)sender
{
    if (![self.txtTitle.text isEqualToString:@""])
    {
        if( store.selectedZone)
        {
            //save project
            store.selectedZone.z_info  = self.txtDescription.text;
            store.selectedZone.z_title = self.txtTitle.text;
            store.selectedZone.proj_id = store.selectedProject.proj_id;
            [DBStore SaveContext];
        }
        else
        {
            //create the project
            store.selectedZone = [DBStore CreateZone:self.txtTitle.text AndInfo:self.txtDescription.text AndProjectID:store.selectedProject.proj_id];
            if (store.selectedZoneTemplate!=nil)
            {
                [TemplateFactory generateAfterZoneCreating];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[store Translate:@"$PO$Warning"] message:[store Translate:@"$PO$NoTitleProvided"] delegate:self cancelButtonTitle:[store Translate:@"$PO$OK"] otherButtonTitles: nil];
        [alert show];
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
