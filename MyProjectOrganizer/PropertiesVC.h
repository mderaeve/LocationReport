//
//  PropertiesVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 28/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "HomeVC.h"
#import "PropertyCell.h"


@interface PropertiesVC : HomeVC <UICollectionViewDataSource, UICollectionViewDelegate, PropertyCellDelegate>

    @property (weak, nonatomic) IBOutlet UICollectionView *colProperties;

@end
