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
    [self performPost:serviceName withParameters:p withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

@end
