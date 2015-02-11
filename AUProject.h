//
//  AUProject.h
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUProject : NSManagedObject

@property (nonatomic, retain) NSNumber * proj_id;
@property (nonatomic, retain) NSString * proj_title;
@property (nonatomic, retain) NSString * proj_info;
@property (nonatomic, retain) NSDate * proj_date;
@property (nonatomic, retain) NSDate * proj_created;
@property (nonatomic, retain) NSString * proj_created_by;
@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * prop_id;
@property (nonatomic, retain) NSString * sectionIdentifier2;
@property (nonatomic, retain) NSString * sectionIdentifier;
@property (nonatomic, retain) NSString * proj_status;
@property (nonatomic, retain) NSNumber * proj_isTemplate;
@property (nonatomic, retain) NSNumber * proj_templateType;
@property (nonatomic, retain) NSNumber * proj_templateUsed_id;

@end
