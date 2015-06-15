//
//  SettingsMenuVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 28/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "SettingsMenuVC.h"
#import "MainView.h"
#import "ProjectHomeVC.h"
#import "SyncService.h"


@interface SettingsMenuVC ()

@end

@implementation SettingsMenuVC
{
    //LeveyPopListView *lplv;
    bool bListOpen;
    UIViewController * senderVC;
    NSMutableArray * optionsToSet;
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
}




-(void) CreateMenu: (UIViewController *) sender
{
    bListOpen=NO;
    optionsToSet=nil;
    UIBarButtonItem * home = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation.png"] style:UIBarButtonItemStylePlain target:self action:@selector(handleHomeButton:)];
    sender.navigationItem.rightBarButtonItem = home;
    senderVC = sender;
}

-(void) handleHomeButton:(id) sender
{
    LeveyPopListView *lplv;
    if (!bListOpen)
    {
        VariableStore * store = [VariableStore sharedInstance];
        if ([senderVC.view isKindOfClass:[UIScrollView class]])
        {
            //Scroll the top scrolview to the top
            ((UIScrollView *)senderVC.view).contentOffset = CGPointMake(0,0);
        }
        optionsToSet = [[NSMutableArray alloc] init];
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"navigation.png"],@"img",[store Translate:@"$PO$Translations"],@"text", nil]];
        if (store.creatingTemplate==YES)
        {
            [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"todo.png"],@"img",[store Translate:@"$PO$EndEditTemplate"],@"text", nil]];
        }
        else
        {
            [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"navigation.png"],@"img",[store Translate:@"$PO$EditTemplates"],@"text", nil]];
        }
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"download.png"],@"img",[store Translate:@"$PO$UpdateTemplates"],@"text", nil]];
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"lock.png"],@"img",[store Translate:@"$PO$UserSettings"],@"text", nil]];
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"navigation.png"],@"img",[store Translate:@"$PO$Cancel"],@"text", nil]];
        
        bListOpen=YES;
        
        lplv   = [[LeveyPopListView alloc] initWithTitle:[store Translate:@"$MOB$Menu"] options:optionsToSet headerImage:@"navigation.png"];

        lplv.delegate=self;
        [lplv showInView:senderVC.view animated:YES];
    }
    else
    {
        bListOpen=NO;
        [lplv removeFromSuperview];
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
    else if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$Translations"]])
    {
        //[senderVC.navigationController popViewControllerAnimated:YES];
        [StoryBoardNavigation NavigateToTranslationsStoryBoard:senderVC];
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$EditTemplates"]])
    {
        optionsToSet=nil;
        [VariableStore sharedInstance].creatingTemplate=YES;
        if ([senderVC class] == [ProjectHomeVC class])
        {
            [(MainView *) senderVC.view SetBackGroundGradient];
            [(ProjectHomeVC *)senderVC getAllProjects];
        }
        //[senderVC.navigationController popViewControllerAnimated:YES];
        //[StoryBoardNavigation NavigateToTypesStoryBoard:senderVC];
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$EndEditTemplate"]])
    {
        optionsToSet=nil;
        [VariableStore sharedInstance].creatingTemplate=NO;
        if ([senderVC class] == [ProjectHomeVC class])
        {
            [(MainView *) senderVC.view SetBackGroundGradient];
            [(ProjectHomeVC *)senderVC getAllProjects];
        }
        //[senderVC.navigationController popToRootViewControllerAnimated:YES];
        //[StoryBoardNavigation NavigateToTypesStoryBoard:senderVC];
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance]  Translate:@"$PO$UserSettings"]])
    {
        [GeneralFunctions showUserToken:senderVC];
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance]  Translate:@"$PO$UpdateTemplates"]])
    {
        //GetTemplatesFromStore
        [SyncService GetTemplates:senderVC.view];
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
