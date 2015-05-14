//
//  HomeVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 08/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ProjectHomeVC.h"
#import "ProjectCell.h"
#import "DateHeader.h"
#import "TemplateChooser.h"
#import "SyncService.h"

@interface ProjectHomeVC ()

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ProjectHomeVC
{
    TemplateChooser * chooser;
    SettingsMenuVC * homeMenu;
    //NSArray * projectArray;
    long nrsections;
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
    VariableStore * store = [VariableStore sharedInstance];

    // Do any additional setup after loading the view.
    [GeneralFunctions TranslateView:self.view];
    [self setTitle:[store Translate:@"$PO$ProjectHome"]];
    [GeneralFunctions MakeRoundView:self.vwReports];
    
    //Get user token if not found
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * userToken = [defaults objectForKey:userTokenDefaultsKey];
    
    if (userToken && ![userToken isEqualToString:@""])
    {
        store.userToken = userToken;
    }
    NSString * userPwd= [defaults objectForKey:userPwdDefaultsKey];
    
    if (userPwd && ![userPwd isEqualToString:@""])
    {
        store.userPwd = userPwd;
    }
    
    if (!store.userToken || !store.userPwd)
    {
        [GeneralFunctions showUserToken:self];
    }
}



- (IBAction)btnSync:(id)sender
{
    [SyncService SyncProducts:self.view];
}

- (IBAction)btnSyncPictures:(id)sender
{
    SyncService* syncPicturesService = [[SyncService alloc] init];
    [syncPicturesService SyncPictures:self.view];
}

- (IBAction)selSortChanged:(id)sender
{
    [self getAllProjects];
}

- (IBAction)btnNewProject:(id)sender
{
    [VariableStore sharedInstance].selectedProject = nil;
    [VariableStore sharedInstance].selectedTemplate = nil;
    //pop up met de vraag of het van template moet komen. als er een template bestaat.
    NSArray * templates = [DBStore GetAllProjects:[NSNumber numberWithInt:1]];
    if (templates.count > 0 && [VariableStore sharedInstance].creatingTemplate==NO)
    {
        if (chooser==nil)
        {
            chooser = [[TemplateChooser alloc] init];
        }
        chooser.projTemplates = templates;
        [chooser ShowTemplateChooser:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"NewProject" sender:self];
    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [self getAllProjects];
    [VariableStore sharedInstance].selectedProject=nil;
    if (homeMenu==nil)
    {
        homeMenu = [[SettingsMenuVC alloc] init];
    }
    [homeMenu CreateMenu:self];
    [super viewDidAppear:animated];
    
}

-(void) getAllProjects
{
    //projectArray = [DBStore GetAllProjects];
   NSError *error;
    if (self.selSort.selectedSegmentIndex==0)
    {
        //standard sort op datum
        self.fetchedResultsController = [DBStore GetProjectDatesByMonthAndYear:nil];
    }
    else
    {
        self.fetchedResultsController = [DBStore GetProjectDatesByMonthAndYearSortedOnTitle:nil];
    }
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
    
    [self.colProjects reloadData];
}

#pragma mark TSearch

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtSearch)
    {
        NSError *error;
        if (self.selSort.selectedSegmentIndex==0)
        {
            //standard sort op datum
            self.fetchedResultsController = [DBStore GetProjectDatesByMonthAndYear:self.txtSearch.text];
        }
        else
        {
            self.fetchedResultsController = [DBStore GetProjectDatesByMonthAndYearSortedOnTitle:self.txtSearch.text];
        }
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
        
        [self.colProjects reloadData];
    }
    return YES;
}

-(BOOL) textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.txtSearch)
    {
        [self getAllProjects];
    }
    return YES;
}

#pragma mark CollectionView
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
    if (collectionView == self.colProjects)
    {
        return CGSizeMake(174.0f, 99.0f);
    }
    else
    {
        // Adjust cell size for orientation
        //if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(50.0f, 50.0f);
        //}
        //return CGSizeMake(670, 84.0f);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DateHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        //NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
        
        if (self.selSort.selectedSegmentIndex == 0)
        {
            static NSDateFormatter *formatter = nil;
            
            if (!formatter)
            {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setCalendar:[NSCalendar currentCalendar]];
                
                NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
                [formatter setDateFormat:formatTemplate];
            }
            
            NSInteger numericSection = [[sectionInfo name] integerValue];
            NSInteger year = numericSection / 1000;
            NSInteger month = numericSection - (year * 1000);
            
            
            
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.year = year;
            dateComponents.month = month;
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
            
            NSString *titleString = [formatter stringFromDate:date];
            
            headerView.lblDate.text = titleString;
            
        }
        else
        {
            headerView.lblDate.text = [sectionInfo name];
        }
        /*id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.row];
        Project *p = [[sectionInfo objects] objectAtIndex:0];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        headerView.lblDate.text = [formatter stringFromDate:p.project_date];*/
        
       // headerView.lblDate.text =
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        
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
        ProjectCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCell" forIndexPath:indexPath];
        
        AUProject *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.lblTitle.text = project.proj_title;
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        cell.txtDate.text = [formatter stringFromDate:project.proj_date];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    AUProject *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [VariableStore sharedInstance].selectedProject = project;
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell * cell = [self.colProjects cellForItemAtIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor darkGrayColor];

    [self performSegueWithIdentifier:@"OpenProject" sender:self];
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
