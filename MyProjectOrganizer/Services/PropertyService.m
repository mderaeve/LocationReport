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

@end
