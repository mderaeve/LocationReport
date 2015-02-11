//
//  HeaderView.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 03/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor colorWithRed:102 green:204 blue:255 alpha:1]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor darkGrayColor]];
        //[self setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:118.0/255.0 blue:173.0/255.0 alpha:1]];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:100/255.0 green:139/255.0 blue:188/255.0 alpha:1] CGColor], (id)[[UIColor colorWithRed:62/255.0 green:109/255.0 blue:165/255.0 alpha:1] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
        //[self setBackgroundColor:[UIColor silver]];
        //[GeneralFunctions MakeRoundView:self];
        [self makeHeaderView2];
    }
    return self;
}

-(void) makeHeaderView2
{
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
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
