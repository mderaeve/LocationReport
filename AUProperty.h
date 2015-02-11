//
//  AUProperty.h
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUProperty : NSManagedObject

@property (nonatomic, retain) NSNumber * prop_id;
@property (nonatomic, retain) NSNumber * prop_seq;
@property (nonatomic, retain) NSString * prop_type;
@property (nonatomic, retain) NSString * prop_value;
@property (nonatomic, retain) NSString * prop_title;
@property (nonatomic, retain) NSDate * prop_created;
@property (nonatomic, retain) NSString * prop_created_by;

@end
