//
//  AddPropertyVC.h
//  LocationReport
//
//  Created by Mark Deraeve on 16/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PropertyDelegate <NSObject>

-(void) PropertyAdded:(AUProperty *) prop;

-(void) PropertyChanged;

@end


@interface AddPropertyVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *selTypes;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtVal;
@property (weak, nonatomic) IBOutlet UITextField *txtPersonVal;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cbxChoice;

@property (strong, nonatomic) id delegate;

@property (strong, nonatomic) AUProperty * property;

@property (strong, nonatomic) NSNumber * propID;

@end
