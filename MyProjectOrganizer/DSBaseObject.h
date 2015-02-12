//
//  DSBaseObject.h
//  BioBodyCare
//
//  Created by Mark Deraeve on 07/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "JSONModel.h"

@interface DSBaseObject : JSONModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;

+ (NSArray *) propertyList;

+(NSString *) serverKeyForProperty:(NSString *) property;
@end
