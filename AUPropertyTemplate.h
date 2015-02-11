//
//  AUPropertyTemplate.h
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUPropertyTemplate : NSManagedObject

@property (nonatomic, retain) NSNumber * templ_id;
@property (nonatomic, retain) NSString * templ_title;
@property (nonatomic, retain) NSString * prop_type;
@property (nonatomic, retain) NSString * prop_title;
@property (nonatomic, retain) NSString * prop_default_value;

@end
