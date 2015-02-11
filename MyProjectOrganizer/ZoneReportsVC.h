//
//  ZoneReportsVC.h
//  LocationReport
//
//  Created by Mark Deraeve on 19/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageThumbView.h"
#import "SubZonesCell.h"
#import "Button+Layout.h"
#import "RoundView.h"
#import "AddPropertyVC.h"
#import "PropertyCell.h"

@interface ZoneReportsVC : HomeVC <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PictureDelegate, PropertyDelegate, PropertyCellDelegate>

@property (nonatomic, retain) UIPopoverController   *popoverController;

@property (weak, nonatomic) IBOutlet UILabel *lblProjectTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectDate;

@property (weak, nonatomic) IBOutlet UILabel *lblProjectDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UICollectionView *colSubReports;
@property (weak, nonatomic) IBOutlet UICollectionView *colPictures;
@property (weak, nonatomic) IBOutlet UICollectionView *colProperties;

@property (weak, nonatomic) IBOutlet RoundView *vwProperties;

@end
