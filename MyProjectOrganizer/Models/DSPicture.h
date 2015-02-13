//
//  DSPicture.h
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSPicture : DSBaseObject

@property (nonatomic, retain) NSString * comp_id;
@property (nonatomic, retain) NSNumber * pic_id;
@property (nonatomic, retain) NSNumber * pic_seq;
@property (nonatomic, retain) NSString * pic_url;
@property (nonatomic, retain) NSDate * pic_created;
@property (nonatomic, retain) NSString * pic_created_by;

@end
