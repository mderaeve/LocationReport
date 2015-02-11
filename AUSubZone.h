//
//  AUSubZone.h
//  LocationReport
//
//  Created by Mark Deraeve on 30/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUSubZone : NSManagedObject

@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * prop_id;
@property (nonatomic, retain) NSString * sectionIdentifier;
@property (nonatomic, retain) NSString * sectionIdentifier2;
@property (nonatomic, retain) NSDate * sz_created;
@property (nonatomic, retain) NSString * sz_created_by;
@property (nonatomic, retain) NSDate * sz_date;
@property (nonatomic, retain) NSNumber * sz_id;
@property (nonatomic, retain) NSString * sz_info;
@property (nonatomic, retain) NSString * sz_title;
@property (nonatomic, retain) NSNumber * z_id;


@end
