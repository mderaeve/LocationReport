//
//  CompanyService.m
//  LocationReport
//
//  Created by Mark Deraeve on 01/04/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "CompanyService.h"

@implementation CompanyService

-(void) getCompanyWithResultHandler:(GetCompanyResultBlock)resultHandler
{
    NSString *serviceName = [NSString stringWithFormat:@"Companies/ByCode/%@/AndPWD/%@",[VariableStore sharedInstance].userToken,[VariableStore sharedInstance].userPwd];
    
    [self performGetRequest:serviceName withParameters:nil withSuccesHandler:^(NSDictionary* result)
     {
         
         if (result)
         {
             
                 NSError *error;
                 DSCompany *c = [[DSCompany alloc] initWithDictionary:result error:&error];
                 
                 if(!error){
                     resultHandler(YES, c, nil);
                 } else {
                     NSLog(@"Error decoding Team: %@", error);
                 }
             
         }
        
     } andErrorHandler:^(NSError *error) {
         resultHandler(NO, nil, error);
     }];
}

@end
