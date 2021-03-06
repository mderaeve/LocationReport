//
//  DBStore.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 02/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "DBStore.h"
#import "POAppDelegate.h"

@implementation DBStore

+ (NSManagedObjectContext *)  GetManagedObjectContext
{
    POAppDelegate * appDelegate = (POAppDelegate *)[[UIApplication sharedApplication]delegate];
    return [appDelegate managedObjectContext];
}

+(void) SaveContext
{
    NSError *error;
    if(![[DBStore GetManagedObjectContext] save:&error])
    {
        NSLog(@"Cannot save context: %@", [error localizedDescription]);
    }
}
+(NSNumber *) GetIDForEntity:(NSString *) entity AndKeyPath:(NSString *) keyPath AndFetchDescription:(NSString *) fetchDescription
{
    NSError * error;
    NSFetchRequest * checkMax = [[NSFetchRequest alloc] init];
    NSEntityDescription * languageDescr = [NSEntityDescription entityForName:entity inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkMax setEntity:languageDescr];
    [checkMax setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpr = [NSExpression expressionForKeyPath:keyPath];
    NSExpression *maxLanguageIDExpr = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpr]];
    
    NSExpressionDescription * expresDescription = [[NSExpressionDescription alloc] init];
    [expresDescription setName:fetchDescription];
    [expresDescription setExpression:maxLanguageIDExpr];
    [expresDescription setExpressionResultType:NSInteger16AttributeType];
    
    [checkMax setPropertiesToFetch:[NSArray arrayWithObject:expresDescription]];
    @try {
        NSArray * values = [[DBStore GetManagedObjectContext] executeFetchRequest:checkMax error:&error];
        if (values != nil || values.count>0)
        {
            long test = [[[values objectAtIndex:0] valueForKey:fetchDescription] longValue];
            test = test+1;
            return [NSNumber numberWithLong:test];
        }
        else
        {
            return [NSNumber numberWithInt:0];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
    @finally {
        //
    }
}

+(NSNumber *) GetMaxForEntity:(NSString *) entity AndKeyPath:(NSString *) keyPath AndFetchDescription:(NSString *) fetchDescription AndPredicate:(NSString *) predicateString
{
    NSError * error;
    NSFetchRequest * checkMax = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:entity inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkMax setEntity:entDescr];
    [checkMax setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpr = [NSExpression expressionForKeyPath:keyPath];
    NSExpression *maxLanguageIDExpr = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpr]];
    
    NSExpressionDescription * expresDescription = [[NSExpressionDescription alloc] init];
    [expresDescription setName:fetchDescription];
    [expresDescription setExpression:maxLanguageIDExpr];
    [expresDescription setExpressionResultType:NSInteger16AttributeType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [checkMax setPredicate:predicate];
    
    [checkMax setPropertiesToFetch:[NSArray arrayWithObject:expresDescription]];
    @try {
        NSArray * values = [[DBStore GetManagedObjectContext] executeFetchRequest:checkMax error:&error];
        if (values != nil || values.count>0)
        {
            long test = [[[values objectAtIndex:0] valueForKey:fetchDescription] longValue];
            test = test+1;
            return [NSNumber numberWithLong:test];
        }
        else
        {
            return [NSNumber numberWithInt:0];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
    @finally {
        //
    }
}

#pragma mark Project

+(AUProject *) CreateProject:(NSString *)title AndInfo:(NSString *)info AndDate:(NSDate *) projectDate
{
    AUProject * p = [NSEntityDescription insertNewObjectForEntityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    //NSNumber * n =  [VariableStore sharedInstance].comp_id;
    p.proj_id = [DBStore GetIDForEntity:@"AUProject" AndKeyPath:@"proj_id" AndFetchDescription:@"maxproj_id"];
    //p.comp_id = n;
    p.proj_title = title;
    p.proj_info   = info;
    p.proj_status = @"Open";
    p.proj_created = [NSDate date];
    p.proj_created_by = [VariableStore sharedInstance].userToken;
    p.proj_date = projectDate;
    p.prop_id = nil;
    p.pic_id = nil;
    p.proj_isTemplate = @([VariableStore sharedInstance].creatingTemplate); //? [NSNumber numberWithInt:1]: [NSNumber numberWithInt:0];
    NSError *error;
    if(![[DBStore GetManagedObjectContext] save:&error])
    {
        NSLog(@"Error saving project to local database: %@", [error localizedDescription]);
    }
    
    return p;
}

+ (NSFetchedResultsController *) GetProjectDatesByMonthAndYear: (NSString *) search
{
   	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
	[fetchRequest setEntity:entity];
    
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    
    if (search != nil && ![search isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(proj_title CONTAINS[cd] %@ or proj_info CONTAINS[cd] %@) and proj_isTemplate = %@",search, search, [VariableStore sharedInstance].creatingTemplate ? @"1": @"0"];
        [fetchRequest setPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proj_isTemplate = %@", [VariableStore sharedInstance].creatingTemplate? @"1": @"0"];
        [fetchRequest setPredicate:predicate];
    }
	// Sort using the timeStamp property.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proj_date" ascending:YES];
	[fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    // Use the sectionIdentifier property to group into sections.
    NSFetchedResultsController * _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DBStore GetManagedObjectContext] sectionNameKeyPath:@"sectionIdentifier" cacheName:@"Root"];
    
	return _fetchedResultsController;
}

+ (NSFetchedResultsController *) GetProjectDatesByMonthAndYearSortedOnTitle: (NSString *) search
{
   	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
	[fetchRequest setEntity:entity];
    
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    
    if (search != nil && ![search isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(proj_title CONTAINS[cd] %@ or proj_info CONTAINS[cd] %@) and proj_isTemplate = %@",search, search, [VariableStore sharedInstance].creatingTemplate? @"1": @"0"];
        [fetchRequest setPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proj_isTemplate = %@", [VariableStore sharedInstance].creatingTemplate? @"1": @"0"];
        [fetchRequest setPredicate:predicate];
    }
	// Sort using the timeStamp property.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proj_title" ascending:YES];
	[fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    // Use the sectionIdentifier property to group into sections.
    NSFetchedResultsController * _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DBStore GetManagedObjectContext] sectionNameKeyPath:@"sectionIdentifier2" cacheName:@"Root"];
    //    _fetchedResultsController.delegate = self;
    
	return _fetchedResultsController;
}

+ (NSArray *) GetAllProjectsForSync
{
    NSError *error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * ProjectEntDescr = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [fetchRequest setEntity:ProjectEntDescr];
    
    NSArray * Projects = [[DBStore GetManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (Projects != nil && Projects.count>0)
    {
        return Projects;
    }
    //Nothing found
    return nil;
}

+ (NSArray *) GetAllProjects:(NSNumber *) fromTemplate
{
    NSError *error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * ProjectEntDescr = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [fetchRequest setEntity:ProjectEntDescr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proj_isTemplate = %@", fromTemplate];
    [fetchRequest setPredicate:predicate];
    
    NSArray * Projects = [[DBStore GetManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (Projects != nil && Projects.count>0)
    {
        return Projects;
    }
    //Nothing found
    return nil;
}

+ (NSArray *) GetOpenProjects
{
    NSError *error;
    NSFetchRequest * checkForProject = [[NSFetchRequest alloc] init];
    NSEntityDescription * ProjectEntDescr = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkForProject setEntity:ProjectEntDescr];
   /* NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status = %@)", languageID];
    [checkForProject setPredicate:predicate];*/
    NSArray * Projects = [[DBStore GetManagedObjectContext] executeFetchRequest:checkForProject error:&error];
    if (Projects != nil && Projects.count>0)
    {
        return Projects;
    }
    //Nothing found
    return nil;
}

+ (NSArray *) SearchProject:(NSString *) search
{
    NSError *error;
    NSFetchRequest * checkForProject = [[NSFetchRequest alloc] init];
    NSEntityDescription * ProjectEntDescr = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkForProject setEntity:ProjectEntDescr];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proj_title CONTAINS[cd] %@ or proj_info CONTAINS[cd] %@ ",search, search];
     [checkForProject setPredicate:predicate];
    NSArray * Projects = [[DBStore GetManagedObjectContext] executeFetchRequest:checkForProject error:&error];
    if (Projects != nil && Projects.count>0)
    {
        return Projects;
    }
    //Nothing found
    return nil;
}

+ (AUProject *) GetProjectTemplateByTitle:(NSString *) title
{
    NSError *error;
    NSFetchRequest * checkForProject = [[NSFetchRequest alloc] init];
    NSEntityDescription * ProjectEntDescr = [NSEntityDescription entityForName:@"AUProject" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkForProject setEntity:ProjectEntDescr];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proj_title CONTAINS[cd] %@ and proj_isTemplate = 1", title];
    [checkForProject setPredicate:predicate];
    NSArray * Projects = [[DBStore GetManagedObjectContext] executeFetchRequest:checkForProject error:&error];
    if (Projects != nil && Projects.count>0)
    {
        return [Projects objectAtIndex:0];
    }
    //Nothing found
    return nil;
}

+ (void) DeleteAllTemplates
{
    NSArray * templates = [DBStore GetAllProjects:[NSNumber numberWithInt:1]];
    
    for (AUProject * t in templates)
    {
        if (t.prop_id && t.prop_id>0)
        {
            NSArray * propertyList = [DBStore GetAllPropertiesForID:t.prop_id];
            for (AUProperty * t_prop in propertyList)
            {
                [DBStore DeleteProperty:t_prop];
            }
        }
        if (t.pic_id && t.pic_id>0)
        {
            NSArray * picList = [DBStore GetPicturesID:t.pic_id];
            for (AUPicture * t_pic in picList)
            {
                [DBStore DeletePicture:t_pic];
            }
        }
        
        NSArray * zoneList = [DBStore GetAllZones:t.proj_id];
        for (AUZone * z in zoneList)
        {
            if (z.prop_id && z.prop_id>0)
            {
                NSArray * propertyList = [DBStore GetAllPropertiesForID:z.prop_id];
                for (AUProperty * z_prop in propertyList)
                {
                    [DBStore DeleteProperty:z_prop];
                }
            }
            if (z.pic_id && z.pic_id>0)
            {
                NSArray * picList = [DBStore GetPicturesID:z.pic_id];
                for (AUPicture * z_pic in picList)
                {
                    [DBStore DeletePicture:z_pic];
                }
            }
            
            NSArray * subzoneList = [DBStore GetAllSubZones:z.z_id];
            
            for (AUSubZone * sz in subzoneList)
            {
                if (sz.prop_id && sz.prop_id>0)
                {
                    NSArray * propertyList = [DBStore GetAllPropertiesForID:sz.prop_id];
                    for (AUProperty * sz_prop in propertyList)
                    {
                        [DBStore DeleteProperty:sz_prop];
                    }
                }
                if (sz.pic_id && sz.pic_id>0)
                {
                    NSArray * picList = [DBStore GetPicturesID:sz.pic_id];
                    for (AUPicture * sz_pic in picList)
                    {
                        [DBStore DeletePicture:sz_pic];
                    }
                }
                
                [DBStore DeleteSubZone:sz];
            }
            
            [DBStore DeleteZone:z];
            
        }
        [DBStore DeleteProject:t];
    }
}

+(void) DeleteProject:(AUProject *)project
{
    [[DBStore GetManagedObjectContext] deleteObject:project];
    [DBStore SaveContext];
}

#pragma mark Zones

+ (AUZone *) CreateZone:(NSString *) title AndInfo:(NSString *) info AndProjectID:(NSNumber *) projectID
{
    AUZone * z = [NSEntityDescription insertNewObjectForEntityForName:@"AUZone" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    //NSNumber * n =  [VariableStore sharedInstance].comp_id;
    z.z_id = [DBStore GetIDForEntity:@"AUZone" AndKeyPath:@"z_id" AndFetchDescription:@"maxz_id"];
    z.proj_id = projectID;
    //z.comp_id = n;
    z.z_title = title;
    z.z_info   = info;
    z.z_created = [NSDate date];
    z.z_created_by = [VariableStore sharedInstance].userToken;
    NSError *error;
    if(![[DBStore GetManagedObjectContext] save:&error])
    {
        NSLog(@"Error saving zone to local database: %@", [error localizedDescription]);
    }
    
    return z;

}

+ (NSArray *) GetOpenZonesForProject:(NSNumber *) projectID
{
    NSError *error;
    NSFetchRequest * check = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUZone" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [check setEntity:entDescr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(proj_id = %@)", projectID];
    [check setPredicate:predicate];    NSArray * Zones = [[DBStore GetManagedObjectContext] executeFetchRequest:check error:&error];
    
    if (Zones != nil && Zones.count>0)
    {
        return Zones;
    }
    //Nothing found
    return nil;
}

+ (NSArray *) GetAllZones:(NSNumber *) projectID
{
    NSError *error;
    NSFetchRequest * check = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUZone" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [check setEntity:entDescr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(proj_id = %@)", projectID];
    [check setPredicate:predicate];
    
    NSArray * Zones = [[DBStore GetManagedObjectContext] executeFetchRequest:check error:&error];
    if (Zones != nil && Zones.count>0)
    {
        return Zones;
    }
    //Nothing found
    return nil;
}

+(void) DeleteZone:(AUZone *)zone
{
    [[DBStore GetManagedObjectContext] deleteObject:zone];
    [DBStore SaveContext];
}

#pragma mark SubZones

+ (AUSubZone *) CreateSubZone:(NSString *) title AndInfo:(NSString *) info AndZoneID:(NSNumber *) zoneID;
{
    AUSubZone * sz = [NSEntityDescription insertNewObjectForEntityForName:@"AUSubZone" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    sz.sz_id = [DBStore GetIDForEntity:@"AUSubZone" AndKeyPath:@"sz_id" AndFetchDescription:@"maxsz_id"];
    sz.z_id = zoneID;
    sz.sz_title = title;
    sz.sz_info   = info;
    sz.sz_created = [NSDate date];
    sz.sz_created_by = [VariableStore sharedInstance].userToken;
    NSError *error;
    if(![[DBStore GetManagedObjectContext] save:&error])
    {
        NSLog(@"Error saving subzone to local database: %@", [error localizedDescription]);
    }
    
    return sz;
}

+ (NSArray *) GetOpenSubZonesForZone:(NSNumber *) zoneID
{
    NSError *error;
    NSFetchRequest * check = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUSubZone" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [check setEntity:entDescr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(z_id = %@)", zoneID];
    [check setPredicate:predicate];
    NSArray * SubZones = [[DBStore GetManagedObjectContext] executeFetchRequest:check error:&error];
    
    if (SubZones != nil && SubZones.count>0)
    {
        return SubZones;
    }
    //Nothing found
    return nil;
}

+ (NSArray *) GetAllSubZones:(NSNumber *) zoneID
{
    NSError *error;
    NSFetchRequest * check = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUSubZone" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [check setEntity:entDescr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(z_id = %@)", zoneID];
    [check setPredicate:predicate];
    
    NSArray * SubZones = [[DBStore GetManagedObjectContext] executeFetchRequest:check error:&error];
    if (SubZones != nil && SubZones.count>0)
    {
        return SubZones;
    }
    //Nothing found
    return nil;
}

+(void) DeleteSubZone:(AUSubZone *)subZone
{
    [[DBStore GetManagedObjectContext] deleteObject:subZone];
    [DBStore SaveContext];
}

#pragma mark Properties

+ (AUProperty *) CreateProperty:(NSString *) title AndValue:(NSString *) value AndType:(NSString *) property_type AndPropertyID:(NSNumber *) propertyID;
{
    AUProperty * p = [NSEntityDescription insertNewObjectForEntityForName:@"AUProperty" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    if([propertyID intValue] > 0)
    {
        p.prop_id = propertyID;
    }
    else
    {
        NSNumber * test = [DBStore GetIDForEntity:@"AUProperty" AndKeyPath:@"prop_id" AndFetchDescription:@"maxprop_id"];
        p.prop_id = test;
    }
    p.prop_type = property_type;
    p.prop_value = value;
    p.prop_title = title;
    int seq = [[DBStore GetMaxForEntity:@"AUProperty" AndKeyPath:@"prop_seq" AndFetchDescription:@"maxseqdescr" AndPredicate:[NSString stringWithFormat:@"prop_id = %@", p.prop_id]] intValue] +1   ;
    p.prop_seq = [NSNumber numberWithInt:seq];
    p.prop_created_by = [VariableStore sharedInstance].userToken;
    p.prop_created = [NSDate date];
    NSError *error;
    if(![[DBStore GetManagedObjectContext] save:&error])
    {
        NSLog(@"Error saving property to local database: %@", [error localizedDescription]);
    }
    
    return p;
}

+ (NSArray *) GetAllPropertiesForID:(NSNumber *)property_id
{
    NSError *error;
    NSFetchRequest * getData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUProperty" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [getData setEntity:entDescr];
    
    NSPredicate * predicate;
    if (property_id!=nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"(prop_id = %@)",property_id];
    }
    
    [getData setPredicate:predicate];
    NSArray * dataArray = [[DBStore GetManagedObjectContext] executeFetchRequest:getData error:&error];
    return dataArray;
}

+ (NSFetchedResultsController *) GetAllPropertiesGroupedByType:(NSNumber *)property_id
{
   	// Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AUProperty" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(prop_id = %@)",property_id];
    [fetchRequest setPredicate:predicate];
    
    
    // Sort using the timeStamp property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"prop_type" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    // Use the sectionIdentifier property to group into sections.
    NSFetchedResultsController * _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DBStore GetManagedObjectContext] sectionNameKeyPath:@"prop_type" cacheName:@"Root"];
    
    return _fetchedResultsController;
}

+(void) DeleteProperty:(AUProperty *) property;
{
    //check if there are more properties with this id, if not, clear the propid from the proj, zone or subzone
    NSArray * props = [DBStore GetAllPropertiesForID:property.prop_id];
    if (props)
    {
        if ( props.count == 1)
        {
            //Delete the prop id from the selected obj
            if([VariableStore sharedInstance].selectedSubZone)
            {
                if ([VariableStore sharedInstance].selectedSubZone.prop_id == property.prop_id)
                {
                    [VariableStore sharedInstance].selectedSubZone.prop_id = nil;
                }
            }
            else if([VariableStore sharedInstance].selectedZone)
            {
                if ([VariableStore sharedInstance].selectedZone.prop_id == property.prop_id)
                {
                    [VariableStore sharedInstance].selectedZone.prop_id = nil;
                }
            }
            else if([VariableStore sharedInstance].selectedProject)
            {
                if ([VariableStore sharedInstance].selectedProject.prop_id == property.prop_id)
                {
                    [VariableStore sharedInstance].selectedProject.prop_id = nil;
                }
            }
        }
    
        [[DBStore GetManagedObjectContext] deleteObject:property];
        [DBStore SaveContext];
    }
}

#pragma mark PropertyTemplate

+ (NSArray *) GetPropertyTemplateByStartLetters:(NSString *) startLetter andTemplateID:(NSNumber *) temp_id
{
    NSError *error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUPropertyTemplate" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [fetchRequest setEntity:entDescr];
    if (startLetter!=nil && ![startLetter isEqualToString:@""] && temp_id != nil)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prop_title BEGINSWITH[c] %@ and templ_id = %@", startLetter, temp_id];
        [fetchRequest setPredicate:predicate];
    }
    else if (temp_id!=nil && (startLetter==nil || [startLetter isEqualToString:@""]))
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(templ_id = %@ and prop_title != nil)", temp_id];
        [fetchRequest setPredicate:predicate];
    }
    else if (temp_id==nil && startLetter!=nil && ![startLetter isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templ_title BEGINSWITH[c] %@ and prop_title = nil", startLetter];
        [fetchRequest setPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prop_title = nil", startLetter];
        [fetchRequest setPredicate:predicate];
    }
    NSArray * arr = [[DBStore GetManagedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (arr != nil && arr.count>0)
    {
        return arr;
    }
    //Nothing found
    return nil;
}

+(AUPropertyTemplate *) GetPropertyTemplateByTemplTitle:(NSString *)templTitle
{
    NSError *error;
    NSFetchRequest * checkForTranslation = [[NSFetchRequest alloc] init];
    NSEntityDescription * wordEntDescr = [NSEntityDescription entityForName:@"AUPropertyTemplate" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkForTranslation setEntity:wordEntDescr];
    
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"templ_title = %@",templTitle];
    
    [checkForTranslation setPredicate:predicate];
    NSArray * returnVals = [[DBStore GetManagedObjectContext] executeFetchRequest:checkForTranslation error:&error];
    
    AUPropertyTemplate * returnVal = nil;
    //Word can only exists once.
    if (returnVals != nil && returnVals.count>0)
    {
        //take the first word and add it to the new category of it doens't exists.
        returnVal = [returnVals objectAtIndex:0];
    }
    
    return returnVal;
}

+(AUPropertyTemplate *) GetPropertyTemplateByTemplateTitle:(NSString *) templateTitle andPropTitle:(NSString *) propTitle;
{
    NSError *error;
    NSFetchRequest * checkForTranslation = [[NSFetchRequest alloc] init];
    NSEntityDescription * wordEntDescr = [NSEntityDescription entityForName:@"AUPropertyTemplate" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkForTranslation setEntity:wordEntDescr];
    
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"prop_title = %@ and templ_title = %@",propTitle, templateTitle];
    
    [checkForTranslation setPredicate:predicate];
    NSArray * returnVals = [[DBStore GetManagedObjectContext] executeFetchRequest:checkForTranslation error:&error];
    
    AUPropertyTemplate * returnVal = nil;
    //Word can only exists once.
    if (returnVals != nil && returnVals.count>0)
    {
        //take the first word and add it to the new category of it doens't exists.
        returnVal = [returnVals objectAtIndex:0];
    }
    
    return returnVal;
}

+ (AUPropertyTemplate *) CreatePropertyTemplate:(NSString *) templ_title AndValue:(NSString *) prop_title AndType:(NSString *) prop_type andTemplateID:(NSNumber *) temp_id
{
    AUPropertyTemplate * templ = [NSEntityDescription insertNewObjectForEntityForName:@"AUPropertyTemplate" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    if (temp_id==nil)
    {
        templ.templ_id = [DBStore GetIDForEntity:@"AUPropertyTemplate" AndKeyPath:@"templ_id" AndFetchDescription:@"maxtempl_id"];
    }
    else
    {
        templ.templ_id = temp_id;
        templ.prop_title = prop_title;
    }
    templ.prop_type = prop_type;
    templ.templ_title = templ_title;
    
    return  templ;
    
    
}

+(void) DeletePropertyTemplate:(AUPropertyTemplate *)propertyTemplate
{
    [[DBStore GetManagedObjectContext] deleteObject:propertyTemplate];
    [DBStore SaveContext];
}

#pragma mark Picture

+ (AUPicture *)CreatePictureWithURL:(NSString *)url AndComment:(NSString *)comment AndPictureID:(NSNumber *) pictureID
{
    AUPicture * pic = [NSEntityDescription insertNewObjectForEntityForName:@"AUPicture" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    if(pictureID)
    {
        pic.pic_id = pictureID;
    }
    else
    {
        pic.pic_id = [DBStore GetIDForEntity:@"AUPicture" AndKeyPath:@"pic_id" AndFetchDescription:@"maxpic_id"];
    }
    //pic.pic_title = title;
    //pic.comment = comment;
    pic.pic_url = url;
    int seq = [[DBStore GetMaxForEntity:@"AUPicture" AndKeyPath:@"pic_seq" AndFetchDescription:@"maxseqdescr" AndPredicate:[NSString stringWithFormat:@"pic_id = %@", pic.pic_id]] intValue] +1   ;
    pic.pic_seq = [NSNumber numberWithInt:seq];
    pic.pic_created = [NSDate date];
    pic.pic_created_by = [VariableStore sharedInstance].userToken;
    //pic.uploaded = NO;
    return pic;
}

+(NSArray *) GetPicturesID:(NSNumber *)pictureID
{
    NSError *error;
    NSFetchRequest * getData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUPicture" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [getData setEntity:entDescr];
    
    NSPredicate * predicate;
    if (pictureID!=nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"(pic_id = %@)",pictureID];
    }
    
    [getData setPredicate:predicate];
    NSArray * dataArray = [[DBStore GetManagedObjectContext] executeFetchRequest:getData error:&error];
    return dataArray;
}

+(NSArray *) GetAllPictures
{
    NSError *error;
    NSFetchRequest * getData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUPicture" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [getData setEntity:entDescr];
    
    NSArray * dataArray = [[DBStore GetManagedObjectContext] executeFetchRequest:getData error:&error];
    return dataArray;
}


+ (void) DeletePicture:(AUPicture *) pic
{
    [[DBStore GetManagedObjectContext] deleteObject:pic];
    [DBStore SaveContext];
}



#pragma mark Translations

+ (NSArray *) GetTranslationsForLanguage:(NSString *) language
{
    NSError *error;
    NSFetchRequest * check = [[NSFetchRequest alloc] init];
    NSEntityDescription * entDescr = [NSEntityDescription entityForName:@"AUTranslation" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [check setEntity:entDescr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trans_language = %@)", language];
    [check setPredicate:predicate];
    
    NSArray * translations = [[DBStore GetManagedObjectContext] executeFetchRequest:check error:&error];
    if (translations != nil && translations.count>0)
    {
        return translations;
    }
    //Nothing found
    return nil;
}

+ (AUTranslation *) CheckTranslation: (NSString *) translation AndLanguageID:(NSString *) language
{
    NSError *error;
    NSFetchRequest * checkForTranslation = [[NSFetchRequest alloc] init];
    NSEntityDescription * wordEntDescr = [NSEntityDescription entityForName:@"AUTranslation" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    [checkForTranslation setEntity:wordEntDescr];
    
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"(trans_tag like[c] %@) and (trans_language = %@)",translation, language];
    
    [checkForTranslation setPredicate:predicate];
    NSArray * Translation = [[DBStore GetManagedObjectContext] executeFetchRequest:checkForTranslation error:&error];
    
    AUTranslation * transToReturn;
    //Word can only exists once.
    if (Translation != nil && Translation.count>0)
    {
        //take the first word and add it to the new category of it doens't exists.
        transToReturn = [Translation objectAtIndex:0];
    }
    else
    {
        //Create word
        transToReturn = [DBStore CreateTranslation:translation AndDescription:[translation stringByReplacingOccurrencesOfString:@"$PO$" withString:@"?"] AndLanguage:language];//createWord;
    }
    
    return transToReturn;
}

+ (AUTranslation *) CreateTranslation: (NSString *) transName AndDescription: (NSString *) description AndLanguage: (NSString *) language
{
    //Check if word does'nt exist for language.
    //If it already exists in another category, then ask if he wants to use the same word or create a new.
    AUTranslation * trans = [NSEntityDescription insertNewObjectForEntityForName:@"AUTranslation" inManagedObjectContext:[DBStore GetManagedObjectContext]];
    trans.trans_language = language;
    trans.trans_tag = transName;
    trans.trans_translated = description;
    
    NSError *error;
    if(![[DBStore GetManagedObjectContext] save:&error])
    {
        NSLog(@"Error saving trans to local database: %@", [error localizedDescription]);
    }
    return trans;
}


@end
