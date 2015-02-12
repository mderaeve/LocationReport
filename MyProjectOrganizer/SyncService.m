//
//  SyncService.m
//  BioBodyCare
//
//  Created by Mark Deraeve on 15/12/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "SyncService.h"
#import "MBProgressHUD.h"


@implementation SyncService

+ (void) SyncProducts:(UIView *) vw
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vw animated:YES];
    hud.mode = MBProgressHUDModeText;
    //hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"Data ophalen en versturen...";
    
    //For each product, sub product, property, picture, zone, property, picture, subzone, property, picture.
    
    NSArray * projectList = [DBStore GetAllProjects:0 ];
    
    for (AUProject * project in projectList)
    {
        
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
