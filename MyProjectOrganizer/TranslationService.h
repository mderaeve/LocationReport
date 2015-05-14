//
//  TranslationService.h
//  LocationReport
//
//  Created by Mark Deraeve on 21/04/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "BaseService.h"
#import "DSTranslation.h"

@interface TranslationService : BaseService

-(void) saveTranslation: (DSTranslation * ) translations;

@end
