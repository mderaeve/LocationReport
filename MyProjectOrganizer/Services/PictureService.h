//
//  PictureService.h
//  LocationReport
//
//  Created by Mark Deraeve on 15/02/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSPicture.h"

@interface PictureService : BaseService

typedef void (^SyncPictureResultBlock)(BOOL success, id errorOrNil);

-(void) syncPicture:(DSPicture *) p withResultHandler:(SyncPictureResultBlock) resultHandler;



@end
