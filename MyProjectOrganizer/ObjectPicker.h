//
//  ObjectPicker.h
//  ZinqProjects
//
//  Created by Mark Deraeve on 13/02/13.
//  Copyright (c) 2013 GalvaPower. All rights reserved.
//

#import "AbstractActionSheetPicker.h"

@class ObjectPicker;

typedef void(^KeyValueObjectPickerDoneBlock)(ObjectPicker *picker, NSInteger selectedIndex, id selectedValue);
typedef void(^KeyValueObjectPickerCancelBlock)(ObjectPicker *picker);

@interface ObjectPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>
/* Create and display an action sheet picker. The returned picker is autoreleased.
 "origin" must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
 "target" must not be empty.  It should respond to "onSuccess" actions.
 "rows" is an array of strings to use for the picker's available selection choices.
 "initialSelection" is used to establish the initially selected row;
 */
+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin descriptionField:(NSString *) descriptionField;

// Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin descriptionField:(NSString *) descriptionField;


@property (nonatomic, copy) KeyValueObjectPickerDoneBlock onActionSheetDone;
@property (nonatomic, copy) KeyValueObjectPickerCancelBlock onActionSheetCancel;
@property (nonatomic, strong) NSString * pickerDescriptionField;

@end