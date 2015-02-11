//
//  SubZonesCell.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "SubZonesCell.h"

@implementation SubZonesCell

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

@end
