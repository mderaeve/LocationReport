//
//  DSSubZone.h
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSSubZone : DSBaseObject

@property (nonatomic, retain) NSNumber * comp_id;
@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * prop_id;
@property (nonatomic, retain) NSDate * sz_created;
@property (nonatomic, retain) NSString * sz_created_by;
@property (nonatomic, retain) NSDate * sz_date;
@property (nonatomic, retain) NSNumber * sz_id;
@property (nonatomic, retain) NSString * sz_info;
@property (nonatomic, retain) NSString * sz_title;
@property (nonatomic, retain) NSNumber * z_id;

@end
