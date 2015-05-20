//
//  AUProject.m
//  LocationReport
//
//  Created by Mark Deraeve on 18/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "AUProject.h"


@implementation AUProject

@dynamic proj_id;
@dynamic proj_title;
@dynamic proj_info;
@dynamic proj_date;
@dynamic proj_created;
@dynamic proj_created_by;
@dynamic pic_id;
@dynamic prop_id;
@dynamic sectionIdentifier2;
@dynamic sectionIdentifier;
@dynamic proj_status;
@dynamic proj_isTemplate;
@dynamic proj_templateType;
@dynamic proj_templateUsed_id;

- (NSString *)sectionIdentifier {
    
    // Create and cache the section identifier on demand.
    
    NSString * tmp;
        NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[self proj_date]];
    tmp = [NSString stringWithFormat:@"%ld", ([components year] * 1000) + [components month]];
    return tmp;
}

- (NSString *)sectionIdentifier2 {
    
    // Create and cache the section identifier on demand.
    
   // NSString * tmp;
    
    NSString *tmp = [[self proj_title] substringToIndex:1];
    
    return tmp;
}

@end
