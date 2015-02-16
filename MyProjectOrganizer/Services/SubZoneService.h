//
//  SubZoneService.h
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSSubZone.h"

@interface SubZoneService : BaseService

typedef void (^SyncSubZoneResultBlock)(BOOL success, id errorOrNil);

-(void) syncSubZone:(DSSubZone *) p withResultHandler:(SyncSubZoneResultBlock) resultHandler;


@end
