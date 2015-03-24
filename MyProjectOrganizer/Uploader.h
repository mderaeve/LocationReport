//
//  Uploader.h
//  AssistUCameraApp
//
//  Created by Mark Deraeve on 28/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UploaderEvents <NSObject>

- (void)sendDidStart:(NSString *) url;
- (void)updateStatus:(NSString *)statusString;
- (void)sendDidStopWithStatus:(NSString *)statusString;

@end

@interface Uploader : NSObject

@property (nonatomic , strong) id delegate;

- (void )sendAction:(UIImage *)image andSubPath:(NSString *) subPath;

@end
