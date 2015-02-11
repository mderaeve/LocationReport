//
//  PropertyNew.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 25/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "PropertyNewCell.h"

@implementation PropertyNewCell

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

- (IBAction)touchDownInTextField:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(StartTypingInNew)])
    {
        [self.delegate StartTypingInNew];
    }
}

- (IBAction)editEnd:(id)sender
{/*
    NSString * prop = self.txtProperty.text;
    NSString * value = self.txtValue.text;
    if (![prop isEqualToString:@""] && ! [value isEqualToString:@""])
    {
        if ([DBStore GetProperty:prop ForSubzoneID:[VariableStore sharedInstance].selectedSubZone.subzone_id]==nil)
        {
            //Save the property for the selected subzone.
            [DBStore CreateProperty:prop AndValue:value AndSubZoneID:[VariableStore sharedInstance].selectedSubZone.subzone_id];
            if ([self.delegate respondsToSelector:@selector(PropertAdded)])
            {
                [self.delegate PropertAdded];
            }
            self.txtProperty.text = @"";
            self.txtValue.text = @"";
        }
        else
        {
            //Explain the property already exists
        }
    }*/

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSString * prop = self.txtProperty.text;
    NSString * value = self.txtValue.text;
    if (![prop isEqualToString:@""] && ! [value isEqualToString:@""])
    {/*
        if ([DBStore GetProperty:prop ForSubzoneID:[VariableStore sharedInstance].selectedSubZone.subzone_id]==nil)
        {
            //Save the property for the selected subzone.
            [DBStore CreateProperty:prop AndValue:value AndSubZoneID:[VariableStore sharedInstance].selectedSubZone.subzone_id];
            if ([self.delegate respondsToSelector:@selector(PropertAdded)])
            {
                [self.delegate PropertAdded];
            }
            self.txtProperty.text = @"";
            self.txtValue.text = @"";
        }
        else
        {
            //Explain the property already exists
        }*/
    }
    return YES;
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
