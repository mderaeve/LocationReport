//
//  BaseService.m
//  BioBodyCare
//
//  Created by Mark Deraeve on 07/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//return @"https://locationreportapi.azurewebsites.net/api";

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

-(NSString *) baseURL
{
   return @"https://locationreportapi.azurewebsites.net/api";
}

-(void) performGetRequest:(NSString *)serviceName withParameters:(id) parameters
        withSuccesHandler:(void (^)(id result)) completion
          andErrorHandler:(void (^)(NSError *error))failure
{
    serviceName = [self encodeURLParts:serviceName];
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager GET:serviceName parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success: %@", responseObject);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             });
             
             if([responseObject isKindOfClass:[NSDictionary class]]){
                 completion([NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject]);
             } else if([responseObject isKindOfClass:[NSArray class]]){
                 completion([NSArray arrayWithArray:(NSArray *) responseObject]);
             } else {
                 completion(responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             });
             
             if([operation.response statusCode] == 200 && error.code == 3840){
                 
                 if(operation.responseString.length > 0 && !([operation.responseString isEqualToString:@"null"])){
                     completion(operation.responseString);
                 } else {
                     completion(nil);
                 }
                 
             } else {
                 [self service:serviceName handleError:error];
                 failure(error);
             }
         }];
}

-(void) performPost:(NSString *) serviceName withParameters:(id) parameters
  withSuccesHandler:(void (^)(id result)) completion
    andErrorHandler:(void (^)(NSError *error))failure {
    
    serviceName = [self encodeURLParts:serviceName];
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    [manager POST:serviceName parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                  [self service:serviceName handleError:error];
                  
                  failure(error);
              }
          }];
    
}

-(void) performDelete:(NSString *) serviceName withParameters:(id) parameters
    withSuccesHandler:(void (^)(id result)) completion
      andErrorHandler:(void (^)(NSError *error))failure {
    
    serviceName = [self encodeURLParts:serviceName];
    
    AFHTTPRequestOperationManager *manager = [self requestOperationManager];
    
    [manager DELETE:serviceName parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    [self service:serviceName handleError:error];
                    
                    failure(error);
                }
            }];
    
}

-(AFHTTPRequestOperationManager*) requestOperationManager {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseURL]];
    
    NSMutableSet *typesSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [typesSet addObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:typesSet];
    
    NSString * authValue = [NSString stringWithFormat:@"%@ %@",@"ACCESS_TOKEN",[VariableStore sharedInstance].userToken];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    manager.operationQueue.maxConcurrentOperationCount = 1;
    
    return manager;
}

-(NSString *) encodeURLParts:(NSString *)input {
    NSString *seperator = @"/";
    
    NSArray *originalParts = [input componentsSeparatedByString:seperator];
    NSMutableArray *encodedParts = [NSMutableArray array];
    for(NSString *part in originalParts){
        [encodedParts addObject:[self urlEncodeStringFromString:part]];
    }
    
    return [encodedParts componentsJoinedByString:seperator];
}

- (NSString *)urlEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
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

-(void) service:(NSString *)serviceName
    handleError:(NSError *) error {
    NSLog(@"SERVER ERROR AFTER %@: %@", serviceName, error);
}
@end




