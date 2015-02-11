//
//  MainView.m
//  LocationReport
//
//  Created by Mark Deraeve on 08/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
    
}

-(void)didMoveToWindow
{
    [self SetBackGroundGradient];
}

-(void) SetBackGroundGradient
{
    if ([[[self.layer sublayers] objectAtIndex:0] class] == [CAGradientLayer class])
    {
        [[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    if ([VariableStore sharedInstance].creatingTemplate==YES)
    {
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255/255.0 green:96/255.0 blue:30/255.0 alpha:1] CGColor], (id)[[UIColor colorWithRed:153/255.0 green:188/255.0 blue:244/255.0 alpha:1] CGColor], nil];
    }
    else
    {
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:55/255.0 green:96/255.0 blue:124/255.0 alpha:1] CGColor], (id)[[UIColor colorWithRed:153/255.0 green:188/255.0 blue:244/255.0 alpha:1] CGColor], nil];
    }
    [self.layer insertSublayer:gradient atIndex:0];
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
