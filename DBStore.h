//
//  DBStore.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 02/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUProject.h"
#import "AUPicture.h"
/*
#import "Company.h"
#import "Devices.h"
*/
#import "AUProperty.h"
#import "AUPropertyTemplate.h"
#import "AUZone.h"
#import "AUSubZone.h"
#import "AUTranslation.h"


@interface DBStore : NSObject

+ (NSManagedObjectContext *)  GetManagedObjectContext;

+(void) SaveContext;

+(NSNumber *) GetMaxForEntity:(NSString *) entity AndKeyPath:(NSString *) keyPath AndFetchDescription:(NSString *) fetchDescription AndPredicate:(NSString *) predicateString;


#pragma mark Projects

+ (AUProject *) CreateProject:(NSString *) title AndInfo:(NSString *) info AndDate:(NSDate *) projectDate;

+ (NSArray *) GetOpenProjects;

+ (NSFetchedResultsController *) GetProjectDatesByMonthAndYear: (NSString *) search;

+ (NSFetchedResultsController *) GetProjectDatesByMonthAndYearSortedOnTitle: (NSString *) search;

+ (NSArray *) GetAllProjects: (NSNumber *) fromTemplate;

+ (NSArray *) SearchProject:(NSString *) search;

#pragma mark Zones

+ (AUZone *) CreateZone:(NSString *) title AndInfo:(NSString *) info AndProjectID:(NSNumber *) projectID;

+ (NSArray *) GetOpenZonesForProject:(NSNumber *) projectID;

+ (NSArray *) GetAllZones:(NSNumber *) projectID;

#pragma mark SubZones

+ (AUSubZone *) CreateSubZone:(NSString *) title AndInfo:(NSString *) info AndZoneID:(NSNumber *) zoneID;

+ (NSArray *) GetOpenSubZonesForZone:(NSNumber *) zoneID;

+ (NSArray *) GetAllSubZones:(NSNumber *) zoneID;

#pragma Persons



#pragma mark Properties

+ (AUProperty *) CreateProperty:(NSString *) title AndValue:(NSString *) value AndType:(NSString *) property_type AndPropertyID:(NSNumber *) propertyID;

+ (NSArray *) GetAllPropertiesForID:(NSNumber *) property_id;

+ (NSFetchedResultsController *) GetAllPropertiesGroupedByType:(NSNumber *)property_id;

+(void) DeleteProperty:(AUProperty *) property;

+ GetPropertyByStartLetters:(NSString *) letters andType:(NSString *) prop_type;

#pragma mark PropertyTemplate

+ (NSArray *) GetPropertyTemplateByStartLetters:(NSString *) letters andTemplateID:(NSNumber *) temp_id;

+ (AUPropertyTemplate *) GetPropertyTemplateByTemplTitle:(NSString *) templTitle;

+ (AUPropertyTemplate *) GetPropertyTemplateByPropTitle:(NSString *) propTitle;

+ (AUPropertyTemplate *) CreatePropertyTemplate:(NSString *) templ_title AndValue:(NSString *) prop_title AndType:(NSString *) prop_type andTemplateID:(NSNumber *) temp_id;

+(void) DeletePropertyTemplate:(AUPropertyTemplate *) propertyTemplate;

#pragma mark Pictures

+ (AUPicture *) CreatePicture:(NSString *)title AndURL:(NSString *) url AndComment:(NSString *) comment AndPictureID:(NSNumber *) pictureID;

+ (NSArray *) GetPicturesID:(NSNumber *) pictureID;

+ (void) DeletePicture:(AUPicture *) pic;

#pragma mark Translations`

+ (NSArray *) GetTranslationsForLanguage:(NSString *) language;

+ (AUTranslation *) CheckTranslation: (NSString *) translation AndLanguageID:(NSString *) language;

#pragma mark Templates



@end
