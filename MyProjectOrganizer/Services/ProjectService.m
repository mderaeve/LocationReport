//
//  ProjectService.m
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "ProjectService.h"

@implementation ProjectService

-(void) syncProject:(DSProject *) p withResultHandler:(SyncProjectsResultBlock) resultHandler
{
    NSString *serviceName = @"Projects";
    NSDictionary* dict = [p toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

-(void) getAllProjects:(GetProjectsResultBlock) resultHandler
{
    
    NSString *serviceName = @"Projects";
    
    [self performGetRequest:serviceName withParameters:nil withSuccesHandler:^(NSDictionary* result)
     {
         NSMutableArray *results = [NSMutableArray array];
         if (results)
         {
             for(NSDictionary *dict in result){
                 NSError *error;
                 DSProject *p = [[DSProject alloc] initWithDictionary:dict error:&error];
                 
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

-(void) getTemplates:(GetProjectsResultBlock) resultHandler
{
    
    NSString *serviceName = @"Projects/Templates";
    
    [self performGetRequest:serviceName withParameters:nil withSuccesHandler:^(NSDictionary* result)
     {
         NSMutableArray *results = [NSMutableArray array];
         if (results)
         {
             for(NSDictionary *dict in result){
                 NSError *error;
                 DSProject *p = [[DSProject alloc] initWithDictionary:dict error:&error];
                 
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
