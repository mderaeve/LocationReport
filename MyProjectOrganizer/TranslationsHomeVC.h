//
//  TranslationsHomeVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 12/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "HomeVC.h"
#import "TransCell.h"
#import "RoundView.h"

@interface TranslationsHomeVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, TransCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colTranslations;



@end
