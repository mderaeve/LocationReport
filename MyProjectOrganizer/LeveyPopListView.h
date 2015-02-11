//
//  LeveyPopListView.h
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeveyPopListViewDelegate;
@interface LeveyPopListView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<LeveyPopListViewDelegate> delegate;
@property (copy, nonatomic) void(^handlerBlock)(NSInteger anIndex);
@property bool CloseAfterSelect;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)sTitle options:(NSArray *)aOptions headerImage:(NSString *) sHeaderImageName;
- (id)initWithTitle:(NSString *)sTitle options:(NSArray *)aOptions headerImage:(NSString *) sHeaderImageName andHeight:(float)height andWidth:(float)width;
/*- (id)initWithTitle:(NSString *)sTitle
 options:(NSArray *)aOptions headerImage:(NSString *) sHeaderImageName
 handler:(void (^)(NSInteger anIndex))aHandlerBlock;*/

// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

-(void) setOptions:(NSArray *) optoins;
@end

@protocol LeveyPopListViewDelegate <NSObject>
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex;
@optional
- (void)leveyPopListViewSelectMultiple:(LeveyPopListView *)popListView didSelectedIndexes:(id)arrIndexes;
- (void)leveyPopListViewDidCancel;
@end