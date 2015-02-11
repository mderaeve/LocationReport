//
//  Button+Layout.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 16/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "Button+Layout.h"

@implementation Button (Layout)

-(void) setToDeselected
{
    [GeneralFunctions MakeNormalButton:self];
}

-(void) setToSelected
{
    [GeneralFunctions MakeSelectedButton:self];
}

@end
