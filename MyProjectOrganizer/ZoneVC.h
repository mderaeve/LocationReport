//
//  ZoneVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 15/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button.h"
#import "SubZonesCell.h"
#import "ImageThumbView.h"
#import "Button+Layout.h"
#import "PropertyCell.h"

@interface ZoneVC : HomeVC <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PropertyCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtProjectTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UISwitch *cbxUploaded;
@property (nonatomic, retain) UIPopoverController   *popoverController;

@property (weak, nonatomic) IBOutlet UICollectionView *colProperties;

@property (weak, nonatomic) IBOutlet Button *btnSave;

@property (weak, nonatomic) IBOutlet UIView *vwDetails;

@end
