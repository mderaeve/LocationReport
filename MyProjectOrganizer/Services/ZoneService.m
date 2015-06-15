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

-(void) getZonesForTemplate:(NSNumber *)proj_id withResultBlock:(GetZonesResultBlock)resultHandler
{
    // [Route("api/Zones/ByProjectTemplate/{projectID}")]
    NSString *serviceName =  [NSString stringWithFormat:@"Zones/ByProjectTemplate/%@",proj_id];
    
    [self performGetRequest:serviceName withParameters:nil withSuccesHandler:^(NSDictionary* result)
     {
         NSMutableArray *results = [NSMutableArray array];
         if (results)
         {
             for(NSDictionary *dict in result){
                 NSError *error;
                 DSZone *z = [[DSZone alloc] initWithDictionary:dict error:&error];
                 
                 if(!error){
                     [results addObject:z];
                 } else {
                     NSLog(@"Error decoding Team: %@", error);
                 }
             }
         }
         resultHandler(YES, [NSArray arrayWithArray:results], nil);
     } andErrorHandler:^(NSError *error) {
         resultHandler(NO, nil, error);
     }];
}

@end
