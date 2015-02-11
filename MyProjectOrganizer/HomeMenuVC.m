//
//  HomeMenuVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//
#import "HomeMenuVC.h"
#import "TemplatesVC.h"

@interface HomeMenuVC ()

@end

@implementation HomeMenuVC
{
    bool bListOpen;
    UIViewController * senderVC;
    NSMutableArray * optionsToSet;
}

-(void) CreateMenu: (UIViewController *) sender
{
    bListOpen=NO;
    [self FillShortMenuOptions];
    
    UIBarButtonItem * home = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"house.png"] style:UIBarButtonItemStylePlain target:self action:@selector(handleHomeButton:)];
    sender.navigationItem.rightBarButtonItem = home;
    senderVC = sender;
}

-(void) handleHomeButton:(id) sender
{
    LeveyPopListView *lplv;
    if (!bListOpen)
    {
        
        if ([senderVC.view isKindOfClass:[UIScrollView class]])
        {
            //Scroll the top scrolview to the top
            ((UIScrollView *)senderVC.view).contentOffset = CGPointMake(0,0);
        }

        bListOpen=YES;
        VariableStore * store = [VariableStore sharedInstance];

        lplv = [[LeveyPopListView alloc] initWithTitle:[store Translate:@"$MOB$Menu"] options:optionsToSet headerImage:@"house.png"];

        lplv.delegate=self;
        [lplv showInView:senderVC.view animated:YES];
    }
    else
    {
        bListOpen=NO;
        [lplv removeFromSuperview];
    }
}

#pragma mark - LeveyPopListView Filler
-(void) FillShortMenuOptions
{
    if (!optionsToSet)
    {
        optionsToSet = [[NSMutableArray alloc] init];
  
        if ([VariableStore sharedInstance].creatingTemplate==YES)
        {
            [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"todo.png"],@"img",[[VariableStore sharedInstance] Translate:@"$PO$EndEditTemplate"],@"text", nil]];
        }
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"house.png"],@"img",[[VariableStore sharedInstance] Translate:@"$PO$Home"],@"text", nil]];
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"navigation.png"],@"img",[[VariableStore sharedInstance] Translate:@"$PO$Cancel"],@"text", nil]];
    }
}

#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    bListOpen=NO;
    NSDictionary * item = optionsToSet[anIndex];
    NSString * itemText = item[@"text"];
    if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$Cancel"]])
    {
        [popListView removeFromSuperview];
        return;
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$Home"]])
    {
        //[senderVC.navigationController popViewControllerAnimated:YES];
        [senderVC.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$EndEditTemplate"]])
    {
        optionsToSet=nil;
        [VariableStore sharedInstance].creatingTemplate=NO;
        [senderVC.navigationController popToRootViewControllerAnimated:YES];
       /* NSArray *viewControllers = senderVC.navigationController.viewControllers;
        NSMutableArray *newViewControllers = [NSMutableArray array];
        
        // preserve the root view controller
        [newViewControllers addObject:[viewControllers objectAtIndex:0]];
        // add the new view controller
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TemplatesStoryboard" bundle:nil];
        UIViewController * vcTo = [sb instantiateInitialViewController];
        [newViewControllers addObject:vcTo];
        // animatedly change the navigation stack
        [senderVC.navigationController setViewControllers:newViewControllers animated:YES];*/
    }
}
- (void)leveyPopListViewDidCancel
{
    bListOpen=NO;
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        VariableStore * store = [VariableStore sharedInstance];
        store.selectedProject = nil;
        store.selectedZone = nil;
        [senderVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
