//
//  TemplateFactory.h
//  LocationReport
//
//  Created by Mark Deraeve on 04/10/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateFactory : NSObject

+ (void) generateAfterProjectCreating;

+(void) generateAfterZoneCreating;

+(void) generateAfterSubZoneCreating;

@end
