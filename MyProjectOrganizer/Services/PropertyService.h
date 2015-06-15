//
//  PropertyService.h
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSProperty.h"

@interface PropertyService : BaseService

typedef void (^SyncPropertyResultBlock)(BOOL success, id errorOrNil);
typedef void (^GetPropertiesResultBlock)(BOOL success, NSArray * properties,  id errorOrNil);

-(void) syncProperty:(DSProperty *) p withResultHandler:(SyncPropertyResultBlock) resultHandler;

-(void) getProperties:(NSNumber *) prop_id withResultBlock:(GetPropertiesResultBlock) resultHandler;

@end
