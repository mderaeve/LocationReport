//
//  PropertyCell.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 25/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUProperty.h"
#import "AUPropertyTemplate.h"

@protocol PropertyCellDelegate <NSObject>

-(void) PropertyDeleted;

//-(void) StartTypingInEdit;

@end

@interface PropertyCell : UICollectionViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblProperty;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteProperty;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) AUProperty * prop;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selValue;

@end
