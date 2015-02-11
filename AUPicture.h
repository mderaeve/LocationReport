//
//  AUPicture.h
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUPicture : NSManagedObject

@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * pic_seq;
@property (nonatomic, retain) NSString * pic_url;
@property (nonatomic, retain) NSDate * pic_created;
@property (nonatomic, retain) NSString * pic_created_by;

@end
