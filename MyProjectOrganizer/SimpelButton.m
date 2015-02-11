//
//  SimpelButton.m
//  LocationReport
//
//  Created by Mark Deraeve on 03/06/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "SimpelButton.h"

@implementation SimpelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [GeneralFunctions MakeSimpleButton:self];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void) awakeFromNib
{
    [GeneralFunctions MakeSimpleButton:self];
}

-(void) highLightView
{
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.25;
}

-(void) cleanHighLightView
{
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
}

-(void) setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        [self highLightView];
    }
    else
    {
        [self cleanHighLightView];
    }
    [super setHighlighted:highlighted];
}

@end
