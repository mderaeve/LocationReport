//
//  PropertyCell.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 25/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "PropertyCell.h"

@implementation PropertyCell

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


- (IBAction)txtValueChanged:(id)sender
{
    _prop.prop_value = _txtValue.text;
    [DBStore SaveContext];
}
- (IBAction)txtTitleChanged:(id)sender
{
    _prop.prop_title = _txtTitle.text;
    [DBStore SaveContext];
}

- (IBAction)selValueChanged:(id)sender
{
    _prop.prop_value = [[VariableStore sharedInstance] Translate:[self.selValue titleForSegmentAtIndex:self.selValue.selectedSegmentIndex]];
    [DBStore SaveContext];
}

- (IBAction)btnDelete:(id)sender
{
    //Delete the property
    if (self.prop)
    {
        //ask if the user is sure?
        [DBStore DeleteProperty:self.prop];
        if ([self.delegate respondsToSelector:@selector(PropertyDeleted)])
        {
            [self.delegate PropertyDeleted];
        }
    }
}

@end
