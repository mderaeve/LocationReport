//
//  PropertyUtil.h
//  BioBodyCare
//
//  Created by Mark Deraeve on 07/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyUtil : NSObject
+ (NSDictionary *) propertiesOfObject:(id)object;
+ (NSDictionary *) propertiesOfClass:(Class)class;
+ (NSDictionary *) propertiesOfSubclass:(Class)class;
@end
