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
typedef void (^GetZonesResultBlock)(BOOL success, NSArray * zones,  id errorOrNil);

-(void) syncZone:(DSZone *) p withResultHandler:(SyncZoneResultBlock) resultHandler;

-(void) getZonesForTemplate:(NSNumber *) proj_id withResultBlock:(GetZonesResultBlock) resultHandler;

@end
