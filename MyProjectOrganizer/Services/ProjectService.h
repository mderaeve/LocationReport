//
//  ProjectService.h
//  LocationReport
//
//  Created by Mark Deraeve on 12/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSProject.h"

@interface ProjectService : BaseService

typedef void (^SyncProjectsResultBlock)(BOOL success, id errorOrNil);
typedef void (^GetProjectsResultBlock)(BOOL success, NSArray * projects,  id errorOrNil);

-(void) syncProject:(DSProject *) p withResultHandler:(SyncProjectsResultBlock) resultHandler;

-(void) getAllProjects:(GetProjectsResultBlock) resultHandler;

-(void) getTemplates: (GetProjectsResultBlock) resultHandler;

@end
