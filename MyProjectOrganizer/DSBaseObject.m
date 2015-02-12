//
//  DSBaseObject.m
//  BioBodyCare
//
//  Created by Mark Deraeve on 07/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"
#import "PropertyUtil.h"

@implementation DSBaseObject
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    NSArray *propsList = [[self class] propertyList];
    for(NSString *key in propsList){
        //NSString *serverKey = [self serverKeyForProperty:key];
        [props setValue:key forKey:key];
    }
    
    return [[JSONKeyMapper alloc] initWithDictionary:[NSDictionary dictionaryWithDictionary:props]];
}

+ (NSArray *) propertyList {
    NSDictionary *properties = [PropertyUtil propertiesOfSubclass:[self class]];
    return [properties allKeys];
}

+(NSString *) serverKeyForProperty:(NSString *) property {
    NSString *serverKey = [property stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                            withString:[[property substringToIndex:1] capitalizedString]];
    return serverKey;
}
@end

