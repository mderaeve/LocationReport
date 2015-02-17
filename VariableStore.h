//
//  VariableStore.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 02/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUProject.h"
#import "AUZone.h"
#import "AUSubZone.h"
#import "AUProperty.h"

@interface VariableStore : NSObject

+ (VariableStore *) sharedInstance;

- (NSString *) Translate:(NSString *) stringToTransLate;

@property (strong, nonatomic) NSNumber * comp_id;
@property (strong, nonatomic) NSString * CompCode;
@property (strong, nonatomic) NSString * DeviceCode;
@property (strong, nonatomic) NSString * LanguageID;

@property (strong, nonatomic) AUProject * selectedProject;
@property (strong, nonatomic) AUZone * selectedZone;
@property (strong, nonatomic) AUSubZone * selectedSubZone;
@property (strong, nonatomic) AUProperty * selectedProperty;

@property (strong, nonatomic) AUProject * selectedTemplate;
@property (strong, nonatomic) AUZone * selectedZoneTemplate;
@property (strong, nonatomic) AUSubZone * selectedSubZoneTemplate;

@property (strong, nonatomic) NSMutableArray * HomeButtonsArray;

@property (strong, nonatomic) NSString * sPersonText;
@property (strong, nonatomic) NSString * sYesNoText;
@property (strong, nonatomic) NSString * sTextText;

@property (nonatomic, retain) NSArray * POTranslations;

@property (nonatomic) BOOL creatingTemplate;

#pragma mark sync

@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, strong) NSString * userPwd;
@property (nonatomic, strong) NSDate * lastSyncDate;

@property (nonatomic, strong) NSString * baseURL;

@end
