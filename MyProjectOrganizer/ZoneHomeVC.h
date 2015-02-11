//
//  ZoneHomeVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 15/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoneHomeVC : HomeVC <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colZones;

@property (weak, nonatomic) IBOutlet UITextField *lblProject;

@end
