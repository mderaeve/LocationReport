//
//  DSProject.h
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSProject : DSBaseObject

@property (nonatomic, retain) NSDate * proj_created;
@property (nonatomic, retain) NSDate * proj_date;
@property (nonatomic, retain) NSNumber * proj_isTemplate;
@property (nonatomic, retain) NSString * proj_info;
@property (nonatomic, retain) NSString * proj_status;
@property (nonatomic, retain) NSString * proj_title;
@property (nonatomic, retain) NSNumber * comp_id;
@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * proj_id;
@property (nonatomic, retain) NSString * proj_created_by;





@property (nonatomic, retain) NSNumber * prop_id;


/*@property (nonatomic, retain) NSNumber * proj_templateType;
@property (nonatomic, retain) NSNumber * proj_templateUsed_id;*/


@end
