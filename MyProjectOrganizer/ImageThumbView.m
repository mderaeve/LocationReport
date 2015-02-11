//
//  ImageThumbView.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 14/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "ImageThumbView.h"

@implementation ImageThumbView

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

- (IBAction)btnDelete:(id)sender
{
    //Delete the property
    if (self.pic)
    {
        [DBStore DeletePicture:self.pic];
        if ([self.delegate respondsToSelector:@selector(PictureDeleted)])
        {
            [self.delegate PictureDeleted];
        }
    }
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
