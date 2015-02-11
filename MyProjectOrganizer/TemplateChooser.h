//
//  TemplateChooser.h
//  LocationReport
//
//  Created by Mark Deraeve on 01/10/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateChooser : UIViewController <LeveyPopListViewDelegate>

@property (strong, nonatomic) NSArray * projTemplates;
@property (strong, nonatomic) NSArray * zTemplates;
@property (strong, nonatomic) NSArray * szTemplates;

-(void) ShowTemplateChooser: (UIViewController *) sender;

@end
