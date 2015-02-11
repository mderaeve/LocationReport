//
//  PropertiesVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 28/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "PropertiesVC.h"
#import "AUProperty.h"
#import "PropertyHeader.h"


@interface PropertiesVC ()
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation PropertiesVC
{
    NSArray * propertiesArray;
    VariableStore * store;
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
    store = [VariableStore sharedInstance];
    //Fill properties
    //propertiesArray = [DBStore GetAllPropertiesForSubZone:store.selectedSubZone.subzone_id];
    [self.colProperties reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self GetProperties];
}

-(void) PropertAdded
{
    //propertiesArray = [DBStore GetAllPropertiesForSubZone:store.selectedSubZone.subzone_id];
    [self.colProperties reloadData];
}

#pragma mark Properties

-(void) GetProperties
{
    NSError *error;
    //sorteren volgens type
    if (store.selectedProject.prop_id>0)
    {
        self.fetchedResultsController = [DBStore GetAllPropertiesGroupedByType:store.selectedProject.prop_id];
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
        
        [self.colProperties reloadData];
    }
}

-(void) PropertyDeleted
{
    [self GetProperties];
}


-(void) StartTypingInEdit
{
    //raiseview
}

-(void) StartTypingInNew
{
    //raiseview
}

#pragma mark CollectionView
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
    return CGSizeMake(762, 54.0f);
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
        cell.txtTitle.text = prop.prop_title;
        if ([prop.prop_type isEqualToString:store.sYesNoText])
        {
            cell.selValue.hidden=NO;
            cell.txtValue.hidden=YES;
            if ([prop.prop_value isEqualToString:[store Translate:@"$PO$Yes"]])
            {
                cell.selValue.selectedSegmentIndex = 0;
            }
            else if ([prop.prop_value isEqualToString:[store Translate:@"$PO$No"]])
            {
                cell.selValue.selectedSegmentIndex = 1;
            }
            else
            {
                cell.selValue.selectedSegmentIndex = 2;
            }
        }
        else
        {
            cell.selValue.hidden=YES;
            cell.txtValue.hidden=NO;
            cell.txtValue.text = prop.prop_value;
            if ([prop.prop_type isEqualToString:[VariableStore sharedInstance].sPersonText])
            {
                //Save
                //Save the person to the person DB
                cell.txtValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
            }
            else if ([prop.prop_type isEqualToString:[VariableStore sharedInstance].sTextText])
            {
                //Save
                cell.txtValue.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            }
        }
        
        [GeneralFunctions TranslateView:cell];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
