//
//  VariableStore.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 02/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore

+ (VariableStore *) sharedInstance
{
    static VariableStore *myInstance = nil;
    
    if (nil == myInstance)
    {
        myInstance = [[[self class] alloc] init];
        myInstance.comp_id = [NSNumber numberWithInt:0];
        myInstance.DeviceCode = @"TESTDEVICE";
        myInstance.CompCode = @"JEZUS";
        myInstance.LanguageID = @"nl";
        myInstance.sPersonText = [myInstance Translate:kPropertyTypePerson];
        myInstance.sYesNoText = [myInstance Translate:kPropertyTypeYesNo];
        myInstance.sTextText = [myInstance Translate:kPropertyTypeText];
        myInstance.sChoiceText = [myInstance Translate:kPropertyTypeChoice];
        myInstance.creatingTemplate = NO;
        myInstance.propPopUpHeight = 544;
        myInstance.propPopUpWidth = 590;
    }
    return myInstance;
}

- (NSString *) Translate:(NSString *) stringToTransLate
{
    AUTranslation * translated;
    if ([stringToTransLate hasPrefix:@"$PO$"])
    {
        translated =  [DBStore CheckTranslation:[stringToTransLate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  AndLanguageID:self.LanguageID];
        if (!translated)
        {
            return [NSString stringWithFormat:@"??%@",stringToTransLate];
        }
        return translated.trans_translated;
    }
    else
    {
        return stringToTransLate;
    }
}

@end
