//
//  TranslationService.m
//  LocationReport
//
//  Created by Mark Deraeve on 21/04/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "TranslationService.h"
#import "DSTranslation.h"

@implementation TranslationService

-(void ) saveTranslation:(DSTranslation *)translations
{
    NSString *serviceName = @"Translation";
    
    NSDictionary* dict = [translations toDictionary];
    [self performPost:serviceName withParameters:dict withSuccesHandler:^(id result) {
        NSLog(@"Trans sync succes");
    } andErrorHandler:^(NSError *error)
     {
         NSLog(@"Trans sync error: %@" , error);
     }];}

@end
