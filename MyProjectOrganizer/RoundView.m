//
//  RoudView.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 03/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "RoundView.h"

@implementation RoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor colorWithRed:204 green:204 blue:204 alpha:0.8]];
        //[self setBackgroundColor:[UIColor lightGrayColor]];
        [GeneralFunctions MakeSimpleRoundView:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
