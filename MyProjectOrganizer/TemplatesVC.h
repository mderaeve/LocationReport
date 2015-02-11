//
//  TemplatesVC.h
//  LocationReport
//
//  Created by Mark Deraeve on 30/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectCell.h"

@interface TemplatesVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colTemplates;

@end
