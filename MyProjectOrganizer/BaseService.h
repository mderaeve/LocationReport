//
//  BaseService.m
//  BioBodyCare
//
//  Created by Mark Deraeve on 07/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

@interface BaseService : NSObject
+ (instancetype) service;

@property (readonly, nonatomic) NSString *baseURL;

-(void) performPost:(NSString *) serviceName withParameters:(id) parameters
  withSuccesHandler:(void (^)(id result)) completion
    andErrorHandler:(void (^)(NSError *error))failure;

-(void) performGetRequest:(NSString *)serviceName withParameters:(id) parameters
        withSuccesHandler:(void (^)(id result)) completion
          andErrorHandler:(void (^)(NSError *error))failure;

/*-(void) performDelete:(NSString *)serviceName withParameters:(id) parameters
    withSuccesHandler:(void (^)(id result)) completion
      andErrorHandler:(void (^)(NSError *error))failure;*/


+ (NSDateFormatter*)dateFormatter;
@end

