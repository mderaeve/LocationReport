//
//  ObjectPicker.m
//  ZinqProjects
//
//  Created by Mark Deraeve on 13/02/13.
//  Copyright (c) 2013 GalvaPower. All rights reserved.
//

#import "ObjectPicker.h"

@interface ObjectPicker()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic, strong) id selectedCode;
@end

@implementation ObjectPicker


+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin descriptionField:(NSString *) descriptionField{
    ObjectPicker *picker = [[ObjectPicker alloc] initWithTitle:title rows:data initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin descriptionField:descriptionField];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin descriptionField:(NSString *) descriptionField{
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.pickerDescriptionField = descriptionField;
        self.data = data;
        self.selectedIndex = index;
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    self.data = nil;
}

- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    [stringPicker selectRow:self.selectedIndex inComponent:0 animated:NO];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, self.selectedIndex, [self.data objectAtIndex:self.selectedIndex]);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:[NSNumber numberWithInt:self.selectedIndex] withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    //NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
    self.selectedCode = (id) [self.data objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = [((id) [self.data objectAtIndex:row]) valueForKey:self.pickerDescriptionField];
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width - 30;
}

@end
