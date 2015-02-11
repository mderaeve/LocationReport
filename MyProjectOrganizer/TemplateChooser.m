//
//  TemplateChooser.m
//  LocationReport
//
//  Created by Mark Deraeve on 01/10/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "TemplateChooser.h"

#define kTemplateTypeProject @"projTemplates"
#define kTemplateTypeZone @"zTemplates"
#define kTemplateTypeSubZone @"szTemplates"

@interface TemplateChooser ()

@end

@implementation TemplateChooser
{
    bool bListOpen;
    NSMutableArray * optionsToSet;
    UIViewController * senderVC;
    NSString * templateType;
    VariableStore * store;
}

-(void) ShowTemplateChooser: (UIViewController *) sender
{
    LeveyPopListView *lplv;
    if (!bListOpen)
    {
        optionsToSet = [[NSMutableArray alloc] init];
        store = [VariableStore sharedInstance];
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"navigation.png"],@"img",[store Translate:@"$PO$Empty"],@"text", nil]];
        if(self.projTemplates)
        {
            
            templateType = kTemplateTypeProject;
            for (AUProject* proj in self.projTemplates)
            {
                [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"todo.png"],@"img",proj.proj_title,@"text", proj, templateType, nil]];
            }
            
        }
        else if( self.zTemplates)
        {
            
            templateType = kTemplateTypeZone;
            for (AUZone* z in self.zTemplates)
            {
                [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"todo.png"],@"img",z.z_title,@"text", z, templateType, nil]];
            }
            
        }
        else if( self.szTemplates)
        {
            templateType = kTemplateTypeSubZone;
            for (AUSubZone* sz in self.szTemplates)
            {
                [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"todo.png"],@"img",sz.sz_title,@"text", sz, templateType, nil]];
            }
        }
        
        [optionsToSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"navigation.png"],@"img",[store Translate:@"$PO$Cancel"],@"text", nil]];
        
        bListOpen=YES;
        lplv = [[LeveyPopListView alloc] initWithTitle:[store Translate:@"$PO$ChooseTemplate"] options:optionsToSet headerImage:@"navigation.png"];
        
        lplv.delegate=self;
        senderVC = sender;
        [lplv showInView:sender.view animated:YES];
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
        store.selectedTemplate = nil;
        [popListView removeFromSuperview];
        return;
    }
    else if ([itemText isEqualToString:[[VariableStore sharedInstance] Translate:@"$PO$Empty"]])
    {
        if ([templateType isEqualToString:kTemplateTypeProject] )
        {
            store.selectedTemplate = nil;
            [senderVC performSegueWithIdentifier:@"NewProject" sender:senderVC];
        }
        else if ([templateType isEqualToString:kTemplateTypeZone] )
        {
            [senderVC performSegueWithIdentifier:@"NewZone" sender:senderVC];
            return;
        }
        else if ([templateType isEqualToString:kTemplateTypeSubZone] )
        {
            [senderVC performSegueWithIdentifier:@"NewSubZone" sender:senderVC];
            return;
        }
        return;
    }
    else
    {
        if ([templateType isEqualToString:kTemplateTypeProject] )
        {
            AUProject * selectedProject = item[templateType];
            store.selectedTemplate = selectedProject;
            //[popListView removeFromSuperview];
            [senderVC performSegueWithIdentifier:@"NewProject" sender:senderVC];
            return;
        }
        else if ([templateType isEqualToString:kTemplateTypeZone] )
        {
            AUZone * selectedZone = item[templateType];
            store.selectedZoneTemplate = selectedZone;
            //[popListView removeFromSuperview];
            [senderVC performSegueWithIdentifier:@"NewZone" sender:senderVC];
            return;
        }
        else if ([templateType isEqualToString:kTemplateTypeSubZone] )
        {
            AUSubZone * selectedSubZone = item[templateType];
            store.selectedSubZoneTemplate = selectedSubZone;
            //[popListView removeFromSuperview];
            [senderVC performSegueWithIdentifier:@"NewSubZone" sender:senderVC];
            return;
        }
    }
}
- (void)leveyPopListViewDidCancel
{
    bListOpen=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
