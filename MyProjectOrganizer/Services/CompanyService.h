//
//  CompanyService.h
//  LocationReport
//
//  Created by Mark Deraeve on 01/04/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSCompany.h"

@interface CompanyService : BaseService

typedef void (^GetCompanyResultBlock)(BOOL success, DSCompany * company, id errorOrNil);

-(void) getCompanyWithResultHandler:(GetCompanyResultBlock) resultHandler;

@end
