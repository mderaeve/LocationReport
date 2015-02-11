//
//  ProjectVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 08/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ProjectVC.h"
#import "AUProject.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageThumbView.h"
#import "PropertyCell.h"
#import "TemplateFactory.h"

@interface ProjectVC ()

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end



@implementation ProjectVC
{
    VariableStore * store;
    NSDate * selectedDate;
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
    store = [VariableStore sharedInstance];
    // Do any additional setup after loading the view.

    if (store.selectedProject != nil)
    {
        [self setTitle:store.selectedProject.proj_title];
    }
    else
    {
        [self setTitle:[[VariableStore sharedInstance] Translate:@"$PO$NewProject"]];
        if (store.selectedTemplate!=nil)
        {
            self.txtInfo.text = store.selectedTemplate.proj_info;
        }
    }
    [self refresh];
    [self InitDatePicker];
    [self showDate];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GetProperties];
}

-(void) InitDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.tag = 1;
    if (store.selectedProject != nil)
    {
        datePicker.date = store.selectedProject.proj_date;
        selectedDate = store.selectedProject.proj_date;
    }
    else if (store.selectedTemplate!=nil)
    {
        datePicker.date = store.selectedTemplate.proj_date;
        selectedDate = store.selectedTemplate.proj_date;
    }
    else
    {
        selectedDate = [NSDate date];
    }
    datePicker.date = selectedDate;
    self.txtProjectDate.inputView = datePicker;
}

-(void)datePickerValueChanged:(id) datePicker
{
    selectedDate = ((UIDatePicker *)datePicker).date;
    [self showDate];
}

-(void) showDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.txtProjectDate.text = [formatter stringFromDate:selectedDate];
    [self.txtProjectDate resignFirstResponder];
}

-(void) refresh
{
    self.vwDetails.hidden=YES;
    if (store.selectedProject)
    {
        self.txtTitle.text = store.selectedProject.proj_title;
        self.txtInfo.text = store.selectedProject.proj_info;
        //self.vwDetails.hidden=NO;
    }
    else
    {
       // fet=nil;
        [self.colProjects reloadData];
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
        self.fetchedResultsController = [DBStore GetAllPropertiesGroupedByType:store.selectedProject.prop_id];
        if (![self.fetchedResultsController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        nrsections = (int)[[self.fetchedResultsController sections] count];
        
        [self.colProjects reloadData];
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
    if (collectionView == self.colProjects)
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

#pragma mark button events

- (IBAction)btnSaveProject:(id)sender
{
    if (![self.txtTitle.text isEqualToString:@""])
    {
        if( store.selectedProject)
        {
            //save project
            store.selectedProject.proj_info  = self.txtInfo.text;
            store.selectedProject.proj_title = self.txtTitle.text;
            store.selectedProject.proj_date = selectedDate;
            [DBStore SaveContext];
        }
        else
        {
            if (store.creatingTemplate==YES)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[store Translate:@"$PO$TemplateType"] message:[store Translate:@"$PO$PleaseChooseTemplateType"] delegate:self cancelButtonTitle:[store Translate:@"$PO$TemplateType"] otherButtonTitles:[store Translate:@"$PO$FullTemplate"], nil];
                [alert show];
            }
            else
            {
                //create the project
                store.selectedProject = [DBStore CreateProject:self.txtTitle.text AndInfo:self.txtInfo.text AndDate:selectedDate];
                //Check for a template and create the needed subclasses.
                if (store.selectedTemplate!=nil)
                {
                    [TemplateFactory generateAfterProjectCreating];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[store Translate:@"$PO$Warning"] message:[store Translate:@"$PO$NoTitleProvided"] delegate:nil cancelButtonTitle:[store Translate:@"$PO$OK"] otherButtonTitles: nil];
        [alert show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    store.selectedProject = [DBStore CreateProject:self.txtTitle.text AndInfo:self.txtInfo.text AndDate:selectedDate];
    if (buttonIndex==0)
    {
        //type
        store.selectedProject.proj_templateType = kTemplateType;
    }
    else
    {
        //full
        store.selectedProject.proj_templateType = kTemplateFull;
    }
    [DBStore SaveContext];
    [self.navigationController popViewControllerAnimated:YES];
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
