//
//  TemplatesVC.m
//  LocationReport
//
//  Created by Mark Deraeve on 30/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "TemplatesVC.h"

@interface TemplatesVC ()

@end

@implementation TemplatesVC
{
    VariableStore * store;
    NSMutableArray * templates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    store = [VariableStore sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAddTemplateClicked:(id)sender
{
    //store.OptionsToSet=nil;
    store.creatingTemplate=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return templates.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

        return CGSizeMake(662.0, 99.0);

}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCell" forIndexPath:indexPath];
    AUProject * proj = [templates objectAtIndex:indexPath.row];
    cell.lblTitle.text = proj.proj_title;
    cell.txtDate.text = proj.proj_info;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
