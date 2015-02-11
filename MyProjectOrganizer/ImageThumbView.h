//
//  ImageThumbView.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 14/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "AUPicture.h"
#import <UIKit/UIKit.h>

@protocol PictureDelegate <NSObject>

-(void) PictureDeleted;

@end

@interface ImageThumbView : UICollectionViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *imgImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) AUPicture * pic;

@property (strong, nonatomic) id delegate;

@end
