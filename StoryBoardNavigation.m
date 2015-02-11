//
//  StoryBoardNavigation.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 15/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "StoryBoardNavigation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PictureEditVC.h"

@implementation StoryBoardNavigation

+(void) NavigateToChangePictureStoryboard:(UIViewController *) vc AndPicture:(UIImage *) image AndPictureObject:(AUPicture *) pic
{
    PictureEditVC * vcTo = [[PictureEditVC alloc] initWithNibName:@"PictureEditVC" bundle:nil];
    vcTo.pic = pic;
    vcTo.imageForMainView = image;
    [UIView transitionWithView:vc.view duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [vc.navigationController pushViewController:vcTo animated:NO];
                    }
                    completion:NULL];

}

+(void) NavigateToTranslationsStoryBoard:(UIViewController *) vc
{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TranslationsStoryboard" bundle:nil];
    UIViewController * vcTo = [sb instantiateInitialViewController];
    [UIView transitionWithView:vc.view duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [vc.navigationController pushViewController:vcTo animated:NO];
                    }
                    completion:NULL];
    
}

+(void) NavigateToTypesStoryBoard:(UIViewController *) vc
{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TemplatesStoryboard" bundle:nil];
    UIViewController * vcTo = [sb instantiateInitialViewController];
    [UIView transitionWithView:vc.view duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [vc.navigationController pushViewController:vcTo animated:NO];
                    }
                    completion:NULL];
}

@end
