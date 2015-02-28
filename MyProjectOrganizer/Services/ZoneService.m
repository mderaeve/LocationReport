//
//  ZoneService.m
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "ZoneService.h"

@implementation ZoneService

-(void) syncZone:(DSZone *)z withResultHandler:(SyncZoneResultBlock)resultHandler
{
    NSString *serviceName = @"Zones";
    NSDictionary* dict = [z toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

@end
