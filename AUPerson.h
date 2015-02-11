//
//  AUPerson.h
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUPerson : NSManagedObject

@property (nonatomic, retain) NSNumber * pers_id;
@property (nonatomic, retain) NSString * pers_firstname;
@property (nonatomic, retain) NSString * pers_lastname;
@property (nonatomic, retain) NSString * pers_email;
@property (nonatomic, retain) NSDate * pers_created;
@property (nonatomic, retain) NSString * pers_created_by;

@end

