//
//  PropertyService.m
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "PropertyService.h"

@implementation PropertyService

-(void)syncProperty:(DSProperty *)p withResultHandler:(SyncPropertyResultBlock)resultHandler
{
    NSString *serviceName = @"Properties";
    NSDictionary* dict = [p toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

-(void) getProperties:(NSNumber *)prop_id withResultBlock:(GetPropertiesResultBlock)resultHandler
{
    NSString *serviceName =  [NSString stringWithFormat:@"Properties/%@",prop_id];

    [self performGetRequest:serviceName withParameters:nil withSuccesHandler:^(NSDictionary* result)
     {
         NSMutableArray *results = [NSMutableArray array];
         if (results)
         {
             for(NSDictionary *dict in result){
                 NSError *error;
                 DSProperty *p = [[DSProperty alloc] initWithDictionary:dict error:&error];
                 
                 if(!error){
                     [results addObject:p];
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
