//
//  SyncService.m
//  BioBodyCare
//
//  Created by Mark Deraeve on 15/12/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "SyncService.h"
#import "MBProgressHUD.h"
#import "ProjectService.h"
#import "ZoneService.h"
#import "SubZoneService.h"
#import "PropertyService.h"
#import "PictureService.h"

@implementation SyncService

+ (void) SyncProducts:(UIView *) vw
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vw animated:YES];
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"Data ophalen en versturen...";
   // VariableStore * store = [VariableStore sharedInstance];
    //For each product, sub product, property, picture, zone, property, picture, subzone, property, picture.
    
    NSArray * projectList = [DBStore GetAllProjects:[NSNumber numberWithInt:0]];
    int i = 0;
    [self SyncProjectWithHud:hud andCounter:i andList:projectList andResultHandler:^(BOOL success, id errorOrNil) {
        if (success)
        {
            [hud hide:YES];
            NSLog(@"Sync Projects Klaar");
            
        }
    }];
    
    
    
   /* [projectService getAllProjects:^(BOOL success, NSArray *projects, id errorOrNil) {
        for (DSProject * p in projects)
        {
            NSLog(p.proj_title);
        }
    }];*/
     
    
    /*ProductService *service = [ProductService service];
    [service getAllProducts:[NSDate date] withResultHandler:^(BOOL success, NSArray * result, id errorOrNil)
    {
        if (result)
        {
            hud.labelText = @"Producten laden...";

            for (DSProduct * p in result)
            {
                if ([p.productID intValue] > 0  )
                {
                    
                    Product * pInContext = [DBStore GetProductByID:p.productID];
                    if (pInContext)
                    {
                        NSLog(@"existing product update it to the DB %@", p.productID);
                        //update
                        pInContext.carbohydrates   = p.carbohydrates;
                        pInContext.energy = p.energy;
                        pInContext.productGroupID = p.productGroupID;
                        pInContext.protein = p.protein;
                        pInContext.sugar = p.sugar;
                        pInContext.title = p.title;
                        pInContext.timeStamp = [NSDate date];
                    }
                    else
                    {
                        NSLog(@"new product add it to the DB %@", p.productID);
                        //insert
                        [DBStore CreateProduct:p.title andProductGroupID:p.productGroupID AndProtein:p.protein AndCarbonHydrates:p.carbohydrates AndEnergy:p.energy AndSugar:p.sugar];
                    }
                }
                else
                {
                    NSLog(@"invalid product");
                }
            }
        }
        [SyncService GetProductGroups:hud andService:service];
    }];
    */
}

+(void) SyncProjectWithHud:(MBProgressHUD *) hud andCounter:(int) i andList:(NSArray *) projectList andResultHandler:(SyncProjectsResultBlock) resultHandler
{
    if(projectList && projectList.count >i)
    {
        AUProject * project = [projectList objectAtIndex:i];
        ProjectService * projectService = [[ProjectService alloc] init];
        hud.labelText = [NSString stringWithFormat:@"Data versturen voor project: %@.", project.proj_title];
        DSProject * p = [[DSProject alloc] init];
        //p.comp_id = store.userToken;
        p.proj_title = project.proj_title;
        p.proj_id = project.proj_id;
        p.proj_info = project.proj_info;
        
        p.prop_id = project.prop_id ? project.prop_id:[NSNumber numberWithInt:0];
        p.pic_id = project.pic_id ? project.pic_id:[NSNumber numberWithInt:0];
        
        p.proj_isTemplate = project.proj_isTemplate;
        p.proj_status = project.proj_status;
        // p.proj_templateType = project.proj_templateType ? project.proj_isTemplate:[NSNumber numberWithInt:0];
        // p.proj_templateUsed_id = project.proj_templateUsed_id ? project.proj_templateUsed_id:[NSNumber numberWithInt:0];
        p.proj_date = project.proj_date;
        p.proj_created_by = p.proj_created_by ? project.proj_created_by : [VariableStore sharedInstance].userToken;
        p.proj_created = project.proj_created;
        p.comp_id = [VariableStore sharedInstance].comp_id;
        i++;
        [projectService syncProject:p withResultHandler:^(BOOL success, id errorOrNil) {
            //Check if its working
            if( success)
            {
                NSLog(@"Succes project sync");
                hud.labelText = [NSString stringWithFormat:@"Data verstuurd voor project: %@!", project.proj_title];
                NSArray * zoneList = [DBStore GetAllZones:project.proj_id];
                int j = 0;
                [self SyncZoneWithHud:hud andCounter:j andList:zoneList andResultHandler:^(BOOL success, id errorOrNil) {
                    if (success)
                    {
                        [hud hide:YES];
                        NSLog(@"Sync Zone Klaar");
                    }
                }];
                if (project.prop_id && project.prop_id>0)
                {
                    int cnt = 0;
                    NSArray * propertyList = [DBStore GetAllPropertiesForID:project.prop_id];
                    [self SyncPropCounter:cnt andList:propertyList];
                }
                if (project.pic_id && project.pic_id>0)
                {
                    int cnt = 0;
                    NSArray * picList = [DBStore GetPicturesID:project.pic_id];
                    [self SyncPicCounter:cnt andList:picList];
                }
            }
            else
            {
                NSLog(@"Fail project sync");
                hud.labelText = [NSString stringWithFormat:@"Data niet verstuurd voor project: %@!", project.proj_title];
            }
            //zichzelf oproepen als er nog projecten over zijn
            [self SyncProjectWithHud:hud andCounter:i andList:projectList andResultHandler:resultHandler];
            
        }];
    }
    else
    {
        [hud hide:YES];
        resultHandler(YES, nil);
    }
}

+(void) SyncZoneWithHud:(MBProgressHUD *) hud andCounter:(int) j andList:(NSArray *) zoneList andResultHandler:(SyncProjectsResultBlock) resultHandler
{
    if(zoneList && zoneList.count >j)
    {
        AUZone * zone = [zoneList objectAtIndex:j];
        ZoneService * zoneService = [[ZoneService alloc] init];
        hud.labelText = [NSString stringWithFormat:@"Data versturen voor zone: %@.", zone.z_title];
        DSZone * z = [[DSZone alloc] init];
        //p.comp_id = store.userToken;
        z.z_title = zone.z_title;
        z.z_info = zone.z_info;
        z.z_created = zone.z_created;
        z.z_created_by = zone.z_created_by;
        z.z_date = zone.z_date;
        z.z_id = zone.z_id;
        z.proj_id = zone.proj_id;
        
        z.prop_id = zone.prop_id ? zone.prop_id:[NSNumber numberWithInt:0];
        z.pic_id = zone.pic_id ? zone.pic_id:[NSNumber numberWithInt:0];
        
        z.comp_id = [VariableStore sharedInstance].comp_id;
        j++;
        [zoneService syncZone:z withResultHandler:^(BOOL success, id errorOrNil) {
            //Check if its working
            if( success)
            {
                NSLog(@"Succes zone sync");
                hud.labelText = [NSString stringWithFormat:@"Data verstuurd voor zone: %@!", zone.z_title];
                NSArray * subZoneList = [DBStore GetAllSubZones:z.z_id];
                int k = 0;
                [self SyncSubZoneWithHud:hud andCounter:k andList:subZoneList andResultHandler:^(BOOL success, id errorOrNil) {
                    if (success)
                    {
                        [hud hide:YES];
                        NSLog(@"Sync Sub Zone Klaar");
                    }
                }];
                if (zone.prop_id && zone.prop_id>0)
                {
                    int cnt = 0;
                    NSArray * propertyList = [DBStore GetAllPropertiesForID:zone.prop_id];
                    [self SyncPropCounter:cnt andList:propertyList];
                }
                if (zone.pic_id && zone.pic_id>0)
                {
                    int cnt = 0;
                    NSArray * picList = [DBStore GetPicturesID:zone.pic_id];
                    [self SyncPicCounter:cnt andList:picList];
                }
            }
            else
            {
                NSLog(@"Sync Zone Fail");
                hud.labelText = [NSString stringWithFormat:@"Data niet verstuurd voor zone: %@!", zone.z_title];
            }
            //zichzelf oproepen als er nog projecten over zijn
            [self SyncZoneWithHud:hud andCounter:j andList:zoneList andResultHandler:resultHandler];
            
        }];
    }
    else
    {
        [hud hide:YES];
        resultHandler(YES, nil);
    }
}

+(void) SyncSubZoneWithHud:(MBProgressHUD *) hud andCounter:(int) j andList:(NSArray *) subZoneList andResultHandler:(SyncProjectsResultBlock) resultHandler
{
    if(subZoneList && subZoneList.count >j)
    {
        AUSubZone * subZone = [subZoneList objectAtIndex:j];
        SubZoneService * subZoneService = [[SubZoneService alloc] init];
        hud.labelText = [NSString stringWithFormat:@"Data versturen voor sub zone: %@.", subZone.sz_title];
        DSSubZone * sz = [[DSSubZone alloc] init];
        //p.comp_id = store.userToken;
        sz.sz_title = subZone.sz_title;
        sz.sz_info = subZone.sz_info;
        sz.sz_created = subZone.sz_created;
        sz.sz_created_by = subZone.sz_created_by;
        sz.sz_date = subZone.sz_date;
        sz.z_id = subZone.z_id;
        sz.sz_id = subZone.sz_id;
        
        sz.prop_id = subZone.prop_id ? subZone.prop_id:[NSNumber numberWithInt:0];
        sz.pic_id = subZone.pic_id ? subZone.pic_id:[NSNumber numberWithInt:0];
        
        sz.comp_id = [VariableStore sharedInstance].comp_id;
        j++;
        [subZoneService syncSubZone:sz withResultHandler:^(BOOL success, id errorOrNil) {
            //Check if its working
            if( success)
            {
                NSLog(@"Succes sub zone sync");
                hud.labelText = [NSString stringWithFormat:@"Data verstuurd voor sub zone: %@!", subZone.sz_title];
                if (subZone.prop_id && subZone.prop_id>0)
                {
                    int cnt = 0;
                    NSArray * propertyList = [DBStore GetAllPropertiesForID:subZone.prop_id];
                    [self SyncPropCounter:cnt andList:propertyList];
                }
                if (subZone.pic_id && subZone.pic_id>0)
                {
                    int cnt = 0;
                    NSArray * picList = [DBStore GetPicturesID:subZone.pic_id];
                    [self SyncPicCounter:cnt andList:picList];
                }
            }
            else
            {
                NSLog(@"Fail sub zone sync");
                hud.labelText = [NSString stringWithFormat:@"Data niet verstuurd voor sub zone: %@!", subZone.sz_title];
            }
            //zichzelf oproepen als er nog projecten over zijn
            [self SyncSubZoneWithHud:hud andCounter:j andList:subZoneList andResultHandler:resultHandler];
            
        }];
    }
    else
    {
        [hud hide:YES];
        resultHandler(YES, nil);
    }
}

+(void) SyncPropCounter:(int) cnt andList:(NSArray *) propList
{
    if(propList && propList.count >cnt)
    {
        AUProperty * prop = [propList objectAtIndex:cnt];
        PropertyService * propService = [[PropertyService alloc] init];
        
        DSProperty * p = [[DSProperty alloc] init];
        p.prop_created = prop.prop_created;
        p.prop_created_by = prop.prop_created_by;
        p.prop_id = prop.prop_id;
        p.prop_seq = prop.prop_seq;
        p.prop_title = prop.prop_title;
        p.prop_type = prop.prop_type;
        p.prop_value = prop.prop_value;
        
        p.comp_id = [VariableStore sharedInstance].comp_id;
        cnt++;
        [propService  syncProperty:p withResultHandler:^(BOOL success, id errorOrNil) {
            //Check if its working
            if( success)
            {
                NSLog(@"Succes prop sync");
            }
            else
            {
                NSLog(@"Fail prop sync");
            }
            //zichzelf oproepen als er nog projecten over zijn
            [self SyncPropCounter:cnt andList:propList];
            
        }];
    }
}

+(void) SyncPicCounter:(int) cnt andList:(NSArray *) picList
{
    if(picList && picList.count >cnt)
    {
        AUPicture * pic = [picList objectAtIndex:cnt];
        PictureService * picService = [[PictureService alloc] init];
        
        DSPicture * p = [[DSPicture alloc] init];
        p.pic_created = pic.pic_created;
        p.pic_created_by = pic.pic_created_by;
        p.pic_id = pic.pic_id;
        p.pic_seq = pic.pic_seq;
        p.pic_url = pic.pic_url;
        
        p.comp_id = [VariableStore sharedInstance].comp_id;
        cnt++;
        [picService  syncPicture:p withResultHandler:^(BOOL success, id errorOrNil) {
            //Check if its working
            if( success)
            {
                NSLog(@"Succes pic sync");
            }
            else
            {
                NSLog(@"Fail pic sync");
            }
            //zichzelf oproepen als er nog projecten over zijn
            [self SyncPicCounter:cnt andList:picList];
            
        }];
    }
}

@end
