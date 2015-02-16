//
//  ZoneService.h
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSZone.h"

@interface ZoneService : BaseService

typedef void (^SyncZoneResultBlock)(BOOL success, id errorOrNil);

-(void) syncZone:(DSZone *) p withResultHandler:(SyncZoneResultBlock) resultHandler;

@end
