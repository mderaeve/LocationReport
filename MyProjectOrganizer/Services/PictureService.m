//
//  PictureService.m
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "PictureService.h"

@implementation PictureService

-(void) syncPicture:(DSPicture *)p withResultHandler:(SyncPictureResultBlock)resultHandler
{
    NSString *serviceName = @"Pictures";
    NSDictionary* dict = [p toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        resultHandler(YES,nil);
    } andErrorHandler:^(NSError *error)
     {
         resultHandler(NO,error);
     }];
}

@end
