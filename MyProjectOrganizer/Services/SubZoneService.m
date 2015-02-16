//
//  SubZoneService.m
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "SubZoneService.h"

@implementation SubZoneService

-(void) syncSubZone:(DSSubZone *)sz withResultHandler:(SyncSubZoneResultBlock)resultHandler
{
    NSString *serviceName = @"SubZone";
    NSDictionary* dict = [sz toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

@end
