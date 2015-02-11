//
//  ProjectVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 08/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button.h"
#import "ImageThumbView.h"
#import "ZoneCell.h"
#import "Button+Layout.h"
#import "PropertyHeader.h"
#import "PropertyCell.h"

@interface ProjectVC : HomeVC <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PropertyCellDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtInfo;
@property (weak, nonatomic) IBOutlet UISwitch *cbxUploeded;

@property (weak, nonatomic) IBOutlet UITextField *txtProjectDate;

@property (weak, nonatomic) IBOutlet UICollectionView *colProjects;
@property (weak, nonatomic) IBOutlet UIView *vwDetails;

@end
