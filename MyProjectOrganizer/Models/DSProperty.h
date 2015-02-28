//
//  DSProperty.h
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSProperty : DSBaseObject

@property (nonatomic, retain) NSNumber * comp_id;
@property (nonatomic, retain) NSNumber * prop_id;
@property (nonatomic, retain) NSNumber * prop_seq;
@property (nonatomic, retain) NSString * prop_type;
@property (nonatomic, retain) NSString * prop_value;
@property (nonatomic, retain) NSString * prop_title;
@property (nonatomic, retain) NSDate * prop_created;
@property (nonatomic, retain) NSString * prop_created_by;

@end
