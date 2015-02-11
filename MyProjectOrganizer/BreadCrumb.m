//
//  BreadCrumb.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 14/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "BreadCrumb.h"
#import "NAVButton.h"

@implementation BreadCrumb

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) CreateCrumb
{
    CGFloat x=0;
    CGFloat y=3;
    for (UIView * vw in self.subviews)
    {
        [vw removeFromSuperview];
    }
    if([VariableStore sharedInstance].selectedProject)
    {
        NAVButton * but = [NAVButton buttonWithType:UIButtonTypeCustom];
        
        CGRect butFrame = CGRectMake(x, y, 250.0, 30.0);
        [but setTitle:[VariableStore sharedInstance].selectedProject.title forState:UIControlStateNormal];
        but.SelectedProject =[VariableStore sharedInstance].selectedProject;
        [but setFrame:butFrame];
        [but addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:but];
        x=x+255;
    }
    if([VariableStore sharedInstance].selectedZone)
    {
        NAVButton * but = [NAVButton buttonWithType:UIButtonTypeCustom];
        
        CGRect butFrame = CGRectMake(x, y, 250.0, 30.0);
        [but setTitle:[VariableStore sharedInstance].selectedZone.title forState:UIControlStateNormal];
        but.SelectedZone=[VariableStore sharedInstance].selectedZone;
        [but setFrame:butFrame];
        [but addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:but];
        x=x+255;
    }
}

-(void) handleClick:(id) sender
{
    
}

@end
