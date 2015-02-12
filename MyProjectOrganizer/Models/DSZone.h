//
//  DSZone.h
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSZone : DSBaseObject

@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * proj_id;
@property (nonatomic, retain) NSNumber * prop_id;
@property (nonatomic, retain) NSString * sectionIdentifier;
@property (nonatomic, retain) NSString * sectionIdentifier2;
@property (nonatomic, retain) NSDate * z_created;
@property (nonatomic, retain) NSString * z_created_by;
@property (nonatomic, retain) NSDate * z_date;
@property (nonatomic, retain) NSNumber * z_id;
@property (nonatomic, retain) NSString * z_info;
@property (nonatomic, retain) NSString * z_title;
@property (nonatomic, retain) NSNumber * z_templateUsed_id;

@end
