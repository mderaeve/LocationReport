//
//  SettingsMenuVC.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 28/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyPopListView.h"

@interface SettingsMenuVC : UIViewController <UIActionSheetDelegate, LeveyPopListViewDelegate>
-(void) CreateMenu: (UIViewController *) sender;
@end
