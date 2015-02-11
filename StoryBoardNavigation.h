//
//  StoryBoardNavigation.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 15/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUPicture.h"

@interface StoryBoardNavigation : NSObject

+(void) NavigateToChangePictureStoryboard:(UIViewController *) vc AndPicture:(UIImage *) image AndPictureObject:(AUPicture *) pic;

+(void) NavigateToTranslationsStoryBoard:(UIViewController *) vc;

+(void) NavigateToTypesStoryBoard:(UIViewController *) vc;

@end
