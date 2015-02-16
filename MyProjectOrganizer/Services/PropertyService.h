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

-(void) syncProperty:(DSProperty *) p withResultHandler:(SyncPropertyResultBlock) resultHandler;


@end
