//
//  GPGButton.m
//  GalvaSFIApp
//
//  Created by Mark Deraeve on 10/03/14.
//  Copyright (c) 2014 Galva Power. All rights reserved.
//

#import "Button.h"

@implementation Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [GeneralFunctions MakeNormalButton:self];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void) awakeFromNib
{
    [GeneralFunctions MakeNormalButton:self];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

-(void) highLightView
{
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.25;
    self.backgroundColor= [UIColor blackColor];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
