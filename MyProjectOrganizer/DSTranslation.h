//
//  DSTranslation.h
//  LocationReport
//
//  Created by Mark Deraeve on 21/04/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSTranslation : DSBaseObject

@property (nonatomic, retain) NSNumber * comp_id;
@property (nonatomic, retain) NSString * trans_language;
@property (nonatomic, retain) NSString * trans_tag;
@property (nonatomic, retain) NSString * trans_translated;
@property (nonatomic, retain) NSDate * created;

@end
