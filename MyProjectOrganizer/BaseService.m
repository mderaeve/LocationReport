//
//  BaseService.m
//  BioBodyCare
//
//  Created by Mark Deraeve on 07/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService
+(instancetype) service {
    return [[[self class] alloc] init];
}

-(NSString *) baseURL {
    VariableStore *store = [VariableStore sharedInstance];
    if (store.baseURL)
    {
        return store.baseURL;
    }
    else
    {
        return @"https://locationreport.azurewebsites.net/api/";
    }
}

-(void) performGetRequest:(NSString *)serviceName withParameters:(NSDictionary *) parameters
        withSuccesHandler:(void (^)(id result)) completion
          andErrorHandler:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableSet *typesSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [typesSet addObject:@"application/json"];
    [typesSet addObject:@"text/html"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:typesSet];
    
    
    NSString * authValue = [NSString stringWithFormat:@"%@ %@",@"ACCESS_TOKEN",[VariableStore sharedInstance].userToken];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];

    manager.requestSerializer = requestSerializer;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.baseURL,serviceName];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            completion([NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject]);
        } else if([responseObject isKindOfClass:[NSArray class]]){
            completion([NSArray arrayWithArray:(NSArray *) responseObject]);
        } else {
            completion(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation.response statusCode] == 200 && error.code == 3840){
            
            if(operation.responseString.length > 0 && !([operation.responseString isEqualToString:@"null"])){
                completion(operation.responseString);
            } else {
                completion(nil);
            }
            
        } else {
            NSLog(@"Error: %@", error);
            failure(error);
        }
    }];
}

-(void) performPost:(NSString *) serviceName withParameters:(id) parameters
  withSuccesHandler:(void (^)(id result)) completion
    andErrorHandler:(void (^)(NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableSet *typesSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [typesSet addObject:@"application/json"];
    [typesSet addObject:@"text/html"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:typesSet];
    
    NSString * authValue = [NSString stringWithFormat:@"%@ %@",@"ACCESS_TOKEN",[VariableStore sharedInstance].userToken];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer = requestSerializer;

    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.baseURL,serviceName];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            completion([NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject]);
        } else if([responseObject isKindOfClass:[NSArray class]]){
            completion([NSArray arrayWithArray:(NSArray *) responseObject]);
        } else {
            completion(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation.response statusCode] == 200 && error.code == 3840){
            completion(nil);
        } else {
            NSLog(@"Error: %@", error);
            failure(error);
        }
        
        failure(error);
    }];
    
}

+ (NSDateFormatter*)dateFormatter {
    static NSDateFormatter* formatter;
    if(formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        NSLocale* enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale: enUS];
        [formatter setLenient: YES];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    }
    return formatter;
}

-(BOOL) isErrorResponse:(id) response {
    return [response isKindOfClass:[NSError class]];
}
@end
