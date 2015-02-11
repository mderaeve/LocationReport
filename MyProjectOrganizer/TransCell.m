//
//  TransCell.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 12/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "TransCell.h"

@implementation TransCell

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

- (IBAction)editBegin:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(EditDidBegin:)])
    {
        [self.delegate EditDidBegin:self];
    }
}

- (IBAction)editEnd:(id)sender
{
    //Save
    self.trans.trans_translated = self.txtDescription.text;
    [DBStore SaveContext];
    
    if ([self.delegate respondsToSelector:@selector(EditDidEnd:)])
    {
        [self.delegate EditDidEnd:self];
    }
}
@end
