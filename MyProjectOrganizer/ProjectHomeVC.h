//
//  HomeVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 08/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsMenuVC.h"
#import "TemplateChooser.h"

@interface ProjectHomeVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colProjects;

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *selSort;

@property (weak, nonatomic) IBOutlet UIView *vwReports;

-(void) getAllProjects;

@end
