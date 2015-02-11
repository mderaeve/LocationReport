//
//  GPGListButton.m
//  GalvaSFIApp
//
//  Created by Mark Deraeve on 11/03/14.
//  Copyright (c) 2014 Galva Power. All rights reserved.
//

#import "ListButton.h"

@implementation ListButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [GeneralFunctions MakeListButton:self];
    }
    return self;
}

-(void) awakeFromNib
{
    [GeneralFunctions MakeListButton:self];
}

-(void) highLightView
{
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.25;
    self.backgroundColor= [UIColor redColor];
}

-(void) cleanHighLightView
{
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
    self.backgroundColor= [UIColor whiteColor];
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
