//
//  ZoneHomeVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 15/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ZoneHomeVC.h"
#import "ZoneCell.h"

@interface ZoneHomeVC ()

@end

@implementation ZoneHomeVC
{
    NSArray * zonesArray;
     VariableStore * store;
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
    self.lblProject.text = [VariableStore sharedInstance].selectedProject.title;
}

-(void) viewDidAppear:(BOOL)animated
{
    zonesArray = [DBStore GetAllZones:[VariableStore sharedInstance].selectedProject.project_id];
    [self.colZones reloadData];
    [super viewDidAppear:animated];
}

- (IBAction)btnNewZone:(id)sender
{
    [VariableStore sharedInstance].selectedZone = nil;
    [self performSegueWithIdentifier:@"OpenZone" sender:self];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.colZones performBatchUpdates:nil completion:nil];
    [self.colZones performBatchUpdates:nil completion:nil];
}

#pragma mark CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return zonesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.colZones)
    {
        // Adjust cell size for orientation
        if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            return CGSizeMake(670, 65.0f);
        }
        return CGSizeMake(476, 65.0f);
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

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.colZones)
    {
        ZoneCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZoneCell" forIndexPath:indexPath];
        Zone * zone = [zonesArray objectAtIndex:indexPath.row];
        cell.lblTitle.text = zone.title;
        return cell;
    }
    else
    {
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    Zone * z = [zonesArray objectAtIndex:indexPath.row];
    [VariableStore sharedInstance].selectedZone = z;
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"OpenZone" sender:self];
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
