//
//  SubZonesVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "SubZonesVC.h"
#import "ImageThumbView.h"
#import "PropertyHeader.h"
#import "TemplateFactory.h"

@interface SubZonesVC ()
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SubZonesVC
{
    bool isBrowse;
    VariableStore * store;

    NSArray * propertiesArray;
   int nrsections;
}


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
    // Do any additional setup after loading the view.
    store = [VariableStore sharedInstance];
    if (store.selectedSubZone != nil)
    {
        [self setTitle:store.selectedSubZone.sz_title];
    }
    else
    {
        [self setTitle:[[VariableStore sharedInstance] Translate:@"$PO$NewSubZone"]];
    }
    // Do any additional setup after loading the view.
    [self refresh];
}

-(void) refresh
{
    self.vwDetails.hidden=YES;
    if (store.selectedSubZone!=nil)
    {
        [self setTitle:store.selectedSubZone.sz_title];
        self.lblProject.text = store.selectedProject.proj_title;
        self.lblZone.text = store.selectedZone.z_title;
        self.txtTitle.text = store.selectedSubZone.sz_title;
        self.txtInfo.text = store.selectedSubZone.sz_info;
        //self.vwDetails.hidden=NO;
    }
    else
    {
        self.lblProject.text = store.selectedProject.proj_title;
        self.lblZone.text = store.selectedZone.z_title;
        //self.vwDetails.hidden=YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GetProperties];
}

/*- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.colPictures performBatchUpdates:nil completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)keyboardWillShow
{
    if (clickedInProperty == YES)
    {
        // Animate the current view out of the way
        if (self.view.frame.origin.y >= 0)
        {
            [GeneralFunctions setViewMovedUp:YES AndView:self.view];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //[GeneralFunctions setViewMovedUp:NO AndView:self.view];
            //screen is up
        }
    }
}

-(void)keyboardWillHide
{
    clickedInProperty=NO;
    if (self.view.frame.origin.y >= 0)
    {
        //Screen is =ok
    }
    else if (self.view.frame.origin.y < 0)
    {
        [GeneralFunctions setViewMovedUp:NO AndView:self.view];
    }
}*/

#pragma mark Properties

-(void) GetProperties
{
    NSError *error;
    //sorteren volgens type
    if (store.selectedSubZone.prop_id>0)
    {
        self.fetchedResultsController = [DBStore GetAllPropertiesGroupedByType:store.selectedSubZone.prop_id];
        if (![self.fetchedResultsController performFetch:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        nrsections = (int)[[self.fetchedResultsController sections] count];
        
        [self.colPictures reloadData];
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
    if (collectionView == self.colPictures)
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

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*AUZone * selectedZone = [zonesArray objectAtIndex:indexPath.row];
     store.selectedZone = selectedZone;
     [self performSegueWithIdentifier:@"EditZone" sender:self];*/
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


- (IBAction)btnSave:(id)sender
{
    if (![self.txtTitle.text isEqualToString:@""])
    {
        if( store.selectedSubZone)
        {
            //save project
            store.selectedSubZone.sz_info  = self.txtInfo.text;
            store.selectedSubZone.sz_title = self.txtTitle.text;
            store.selectedSubZone.z_id = store.selectedZone.z_id;
            //store.selectedSubZone.subzonetype_id = selectedSubType;
            [DBStore SaveContext];
        }
        else
        {
            //create the project
            store.selectedSubZone = [DBStore CreateSubZone:self.txtTitle.text AndInfo:self.txtInfo.text AndZoneID:store.selectedZone.z_id];
            if (store.selectedSubZoneTemplate!=nil)
            {
                [TemplateFactory generateAfterSubZoneCreating];
            }
           // store.selectedSubZone.subzonetype_id = selectedSubType;
            [DBStore SaveContext];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
