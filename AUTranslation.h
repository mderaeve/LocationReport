//
//  AUTranslation.h
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AUTranslation : NSManagedObject

@property (nonatomic, retain) NSString * trans_language;
@property (nonatomic, retain) NSString * trans_tag;
@property (nonatomic, retain) NSString * trans_translated;

@end
