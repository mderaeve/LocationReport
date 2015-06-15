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
    NSString *serviceName = @"SubZones";
    NSDictionary* dict = [sz toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

-(void) getSubZonesForTemplate:(NSNumber *)z_id withResultBlock:(GetSubZonesResultBlock)resultHandler
{
    //api/SubZones/ByZoneTemplate/{zoneID}
    NSString *serviceName =  [NSString stringWithFormat:@"SubZones/ByZoneTemplate/%@",z_id];
    
    [self performGetRequest:serviceName withParameters:nil withSuccesHandler:^(NSDictionary* result)
     {
         NSMutableArray *results = [NSMutableArray array];
         if (results)
         {
             for(NSDictionary *dict in result){
                 NSError *error;
                 DSSubZone *sz = [[DSSubZone alloc] initWithDictionary:dict error:&error];
                 
                 if(!error){
                     [results addObject:sz];
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
