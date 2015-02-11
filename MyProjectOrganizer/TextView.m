//
//  TextView.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 21/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "TextView.h"

@implementation TextView

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
        [GeneralFunctions MakeTextField:self];
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
