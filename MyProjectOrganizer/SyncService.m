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


@implementation SyncService

+ (void) SyncProducts:(UIView *) vw
{
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vw animated:YES];
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"Data ophalen en versturen...";
    VariableStore * store = [VariableStore sharedInstance];
    //For each product, sub product, property, picture, zone, property, picture, subzone, property, picture.
    
    NSArray * projectList = [DBStore GetAllProjects:[NSNumber numberWithInt:0]];
    ProjectService * projectService = [[ProjectService alloc] init];
    
    /*[projectService getAllProjects:^(BOOL success, NSArray *projects, id errorOrNil) {
        for (DSProject * p in projects)
        {
            NSLog(p.proj_title);
        }
    }];*/
     
    if(projectList && projectList.count >0)
    {
        for (AUProject * project in projectList)
        {
            DSProject * p = [[DSProject alloc] init];
            //p.comp_id = store.userToken;
            p.proj_title = project.proj_title;
            p.proj_id = project.proj_id;
            p.proj_info = project.proj_info;
            
            p.prop_id = project.prop_id ? project.prop_id:[NSNumber numberWithInt:0];
            p.pic_id = project.pic_id ? project.pic_id:[NSNumber numberWithInt:0];
            p.proj_date = project.proj_date;
            p.proj_isTemplate = project.proj_isTemplate;
            p.proj_status = project.proj_status;
            p.proj_templateType = project.proj_templateType ? project.proj_isTemplate:[NSNumber numberWithInt:0];
            p.proj_templateUsed_id = project.proj_templateUsed_id ? project.proj_templateUsed_id:[NSNumber numberWithInt:0];
            p.proj_date = project.proj_date;
            p.proj_created_by = p.proj_created_by ? project.proj_created_by : store.userToken;
            p.proj_created = project.proj_created;
            [projectService syncProject:p withResultHandler:^(BOOL success, id errorOrNil) {
                //Check if its working
                [hud hide:YES];
            }];
            
            
        }
    }
    else
    {
        [hud hide:YES];
    }
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
/*
+(void) GetProductGroups:(MBProgressHUD *) hud andService:(ProductService *) service
{
    hud.labelText = @"Product groepen laden...";
    hud.progress = 0;
    [service getAllProductGroups:[NSDate date] withResultHandler:^(BOOL succes, NSArray * result, id errorOrNil)
     {
         if (result )
         {
             for (DSProductGroups * pg in result)
             {
                 if ([pg.productGroupID intValue] > 0  )
                 {
                     
                     ProductGroup * pgInContext = [DBStore GetProductGroupByID:pg.productGroupID];
                     if (pgInContext)
                     {
                         //update
                         pgInContext.title = pg.title;
                         pgInContext.timeStamp = [NSDate date];
                         NSLog(@"existing product group update it to the DB %@", pg.productGroupID);
                     }
                     else
                     {
                         NSLog(@"new product group add it to the DB %@", pg.productGroupID);
                         //insert
                         [DBStore CreateProductGroup:pg.title];
                     }
                 }
                 else
                 {
                     NSLog(@"invalid product");
                 }
             }
         }
         [SyncService GetMoments:hud andService:service];
         
     }];
}*/

/*

+(void) SendMeals:(MBProgressHUD *) hud
{
    hud.labelText = @"Maaltijden doorsturen...";
    NSArray * meals = [DBStore GetChangedMeals];
    NSMutableArray * mealsToSend = [[NSMutableArray alloc] init];
    //int counter = 0;
    for (Meals * m in meals)
    {
        DSMeals * mToSend = [[DSMeals alloc] init];
        mToSend.carbohydrates = m.carbohydrates;
        mToSend.meal = m.meal;
        mToSend.mealID = m.mealID;
        mToSend.moment = m.moment;
        mToSend.momentID = m.momentID;
        mToSend.productID = m.productID;
        mToSend.protein = m.protein;
        mToSend.timeStamp = m.day;
        mToSend.quantity = m.quantity;
        
        [mealsToSend addObject:[mToSend toDictionary]];
        //[mealsToSend setObject:mToSend forKey:[NSString stringWithFormat:@"%d",counter]];
        //counter++;
    }
    
    //NSDictionary * dictToSend = [NSDictionary dictionaryWithObject:mealsToSend forKey:@"meals"];
    MealsService * mealsService = [MealsService service];
    [mealsService insertMeals:mealsToSend withResultHandler:^(BOOL succes, id errorOrNil)
     {
         if (succes == YES)
         {
             NSLog(@"Succes");
         }
         [hud hide:YES];
     }];
    
    
    if (![VariableStore sharedInstance].lastSyncDate)
    {
        [VariableStore sharedInstance].lastSyncDate = [NSDate date];
    }
}*/

@end
