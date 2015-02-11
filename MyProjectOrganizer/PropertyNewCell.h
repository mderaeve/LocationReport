//
//  PropertyNew.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 25/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewPropertyDelegate <NSObject>

-(void) PropertAdded;

-(void) StartTypingInNew;

@end

@interface PropertyNewCell : UICollectionViewCell <UITextFieldDelegate>

@property (strong, nonatomic) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtProperty;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selValue;

@end
