//
//  SubZonesVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "HomeVC.h"
#import "Button.h"
#import "ImageThumbView.h"
#import "PropertyCell.h"
#import "Button+Layout.h"
#import "ObjectPicker.h"

@interface SubZonesVC : HomeVC <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PropertyCellDelegate>

@property (weak, nonatomic) IBOutlet Button *btnSaveSubZone;

@property (weak, nonatomic) IBOutlet UIView *vwDetails;

@property (weak, nonatomic) IBOutlet UICollectionView *colPictures;

@property (weak, nonatomic) IBOutlet UITextField *lblProject;
@property (weak, nonatomic) IBOutlet UITextField *lblZone;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtInfo;
@property (weak, nonatomic) IBOutlet UISwitch *cbxUploaded;

@end
