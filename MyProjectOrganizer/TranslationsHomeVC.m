//
//  TranslationsHomeVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 12/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "TranslationsHomeVC.h"

@interface TranslationsHomeVC ()

@end

@implementation TranslationsHomeVC
{
    NSArray * translationsArray;
    NSIndexPath * selectedIndexPath;
    bool moveScreen;
    bool up;
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
    [GeneralFunctions TranslateView:self.view];
    translationsArray = [DBStore GetTranslationsForLanguage:[VariableStore sharedInstance].LanguageID];
    [self.colTranslations reloadData];
    moveScreen=NO;
    up=NO;
}

- (void)viewWillAppear:(BOOL)animated
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
    if (moveScreen==YES)
    {
        [GeneralFunctions setViewMovedUp:YES AndView:self.view];
        up=YES;
    }
    else
    {
        up=NO;
    }
}

-(void)keyboardWillHide
{
    if (moveScreen==YES && up==YES)
    {
        [GeneralFunctions setViewMovedUp:NO AndView:self.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return translationsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(680, 65.0f);
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TransCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TransCell" forIndexPath:indexPath];
    AUTranslation * trans = [translationsArray objectAtIndex:indexPath.row];
    cell.lblTag.text = trans.trans_tag;
    cell.txtDescription.text = trans.trans_translated;
    cell.trans = trans;
    cell.delegate = self;
    return cell;
    
}


-(void) EditDidEnd:(UICollectionViewCell *)cell
{
    //moveScreen=NO;
}

-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    //[self SetMove:indexPath];
}

-(void) EditDidBegin:(UICollectionViewCell *)cell
{
    NSIndexPath * path = [self.colTranslations indexPathForCell:cell];
    [self SetMove:path];
}

-(void) SetMove:(NSIndexPath *) indexPath
{
    UICollectionViewLayoutAttributes *attributes = [self.colTranslations layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellRect = attributes.frame;
    
    CGRect cellFrameInSuperview = [self.colTranslations convertRect:cellRect toView:[self.colTranslations superview]];
    
    NSLog(@"%f",cellFrameInSuperview.origin.y);
    if (cellFrameInSuperview.origin.y > kOFFSET_FOR_KEYBOARDHOR)
    {
        moveScreen=YES;
    }
    else
    {
        moveScreen=NO;
    }
}

@end
