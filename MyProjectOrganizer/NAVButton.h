//
//  NAVButton.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 14/05/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "Button.h"

@interface NAVButton : Button

@property (nonatomic, strong) AUProject * SelectedProject;

@property (nonatomic, strong) AUZone * SelectedZone;

@property (nonatomic, strong) AUSubZone * SelectedSubZone;


@end
