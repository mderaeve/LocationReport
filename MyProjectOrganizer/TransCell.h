//
//  TransCell.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 12/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransCellDelegate <NSObject>

-(void) EditDidBegin:(UICollectionViewCell *) cell;

-(void) EditDidEnd:(UICollectionViewCell *) cell;

@end



@interface TransCell : UICollectionViewCell

@property (nonatomic, strong) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;

@property (strong, nonatomic) AUTranslation * trans;

@end
