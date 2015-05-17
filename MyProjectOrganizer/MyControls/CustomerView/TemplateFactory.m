//
//  TemplateFactory.m
//  LocationReport
//
//  Created by Mark Deraeve on 04/10/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "TemplateFactory.h"

@implementation TemplateFactory

//templatetype 

+ (void) generateAfterProjectCreating
{
    [VariableStore sharedInstance].selectedProject.proj_templateUsed_id = [VariableStore sharedInstance].selectedTemplate.proj_id;
    [VariableStore sharedInstance].selectedProject.proj_templateType = [VariableStore sharedInstance].selectedTemplate.proj_templateType;
    [VariableStore sharedInstance].selectedProject.proj_title = [VariableStore sharedInstance].selectedTemplate.proj_title;
    
    if ([DBStore GetAllPropertiesForID:[VariableStore sharedInstance].selectedTemplate.prop_id] != nil)
    {
        //Copy all template properties to the selected project
        NSArray * allPropertiesToAddToProject = [DBStore GetAllPropertiesForID:[VariableStore sharedInstance].selectedTemplate.prop_id];
        AUProperty * newProp;
        for (AUProperty * prop in allPropertiesToAddToProject)
        {
            if(newProp)
            {
                [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:newProp.prop_id];
            }
            else
            {
                newProp = [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:nil];
                [VariableStore sharedInstance].selectedProject.prop_id = newProp.prop_id;
                //[DBStore SaveContext];
            }
        }
    }
    if ([[VariableStore sharedInstance].selectedTemplate.proj_templateType  isEqual: kTemplateFull])
    {
        NSArray * zones = [DBStore GetAllZones:[VariableStore sharedInstance].selectedTemplate.proj_id];
        for (AUZone * templateZone in zones)
        {
            //Add all zone to project
            AUZone * newZone = [DBStore CreateZone:templateZone.z_title AndInfo:templateZone.z_info AndProjectID:[VariableStore sharedInstance].selectedProject.proj_id];
            
            if (templateZone.prop_id != nil)
            {
                //Add all properties to zone
                NSArray * allPropertiesToAddToZone = [DBStore GetAllPropertiesForID:templateZone.prop_id];
                AUProperty * newZoneProp;
                for (AUProperty * prop in allPropertiesToAddToZone)
                {
                    if(newZoneProp)
                    {
                        [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:newZoneProp.prop_id];
                    }
                    else
                    {
                        newZoneProp = [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:nil];
                        newZone.prop_id = newZoneProp.prop_id;
                        //[DBStore SaveContext];
                    }
                }
            }
            NSArray * subZones = [DBStore GetAllSubZones:templateZone.z_id];
            for (AUSubZone * templateSubZone in subZones)
            {
                //Add all zone to project
                AUSubZone * newSubZone = [DBStore CreateSubZone:templateSubZone.sz_title AndInfo:templateSubZone.sz_info AndZoneID:newZone.z_id];
               
                if (templateSubZone.prop_id!=nil)
                {
                    //Add all properties to zone
                    NSArray * allPropertiesToAddToSubZone = [DBStore GetAllPropertiesForID:templateSubZone.prop_id];
                    AUProperty * newSubZoneProp;
                    for (AUProperty * prop in allPropertiesToAddToSubZone)
                    {
                        if(newSubZoneProp)
                        {
                            [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:newSubZoneProp.prop_id];
                        }
                        else
                        {
                            newSubZoneProp = [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:nil];
                            newSubZone.prop_id = newSubZoneProp.prop_id;
                            //[DBStore SaveContext];
                        }
                    }
                }
            }
        }
    }
    [DBStore SaveContext];
}

+(void) generateAfterZoneCreating
{
    [VariableStore sharedInstance].selectedZone.z_templateUsed_id = [VariableStore sharedInstance].selectedZoneTemplate.z_id;
    NSArray * allPropertiesToAddToZone = [DBStore GetAllPropertiesForID:[VariableStore sharedInstance].selectedZoneTemplate.prop_id];
    AUProperty * newZoneProp;
    for (AUProperty * prop in allPropertiesToAddToZone)
    {
        if(newZoneProp)
        {
            [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:newZoneProp.prop_id];
        }
        else
        {
            newZoneProp = [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:nil];
            [VariableStore sharedInstance].selectedZone.prop_id = newZoneProp.prop_id;
            //[DBStore SaveContext];
        }
    }
}

+(void) generateAfterSubZoneCreating
{
    NSArray * allPropertiesToAddToSubZone = [DBStore GetAllPropertiesForID:[VariableStore sharedInstance].selectedSubZoneTemplate.prop_id];
    AUProperty * newSubZoneProp;
    for (AUProperty * prop in allPropertiesToAddToSubZone)
    {
        if(newSubZoneProp)
        {
            [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:newSubZoneProp.prop_id];
        }
        else
        {
            newSubZoneProp = [DBStore CreateProperty:prop.prop_title AndValue:prop.prop_value AndType:prop.prop_type AndPropertyID:nil];
            [VariableStore sharedInstance].selectedSubZone.prop_id = newSubZoneProp.prop_id;
            //[DBStore SaveContext];
        }
    }
}

@end
