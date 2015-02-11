//
//  ProjectCell.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 08/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;

@end
