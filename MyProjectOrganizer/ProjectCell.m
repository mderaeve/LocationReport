//
//  ProjectCell.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 08/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [GeneralFunctions MakeCollViewCell:self];
    }
    return self;
}

-(void) awakeFromNib
{
    
    
    [GeneralFunctions MakeCollViewCell:self];
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
