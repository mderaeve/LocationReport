//
//  GeneralFunctions.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 02/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralFunctions : NSObject

+(void) showUserToken:(UIViewController * ) vc;

+ (void) MakeSimpleRoundView:(UIView *) vw;

+ (void) MakeRoundView:(UIView *) vw;

+ (void) MakeRoundView:(UIView *) vw WithCornerRadius:(CGFloat) radius;

+ (void) MakeListButton:(UIView *) vw;

+ (void) MakeNormalButton:(UIView *) vw;

+ (void) MakeSimpleButton:(UIView *) vw;

+ (void) MakeSelectedButton:(UIView *) vw;

+ (void) MakeListItemView:(UIView *) vw;

+ (void) MakeCollViewCell:(UIView *) vw;

+(void) MakeTextField:(UITextView *) vw;

+ (void) TranslateView: (UIView *) vw;

+(void)setViewMovedUp:(BOOL)movedUp AndView:(UIView *) vw;

@end
