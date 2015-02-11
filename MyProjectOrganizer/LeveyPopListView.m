//
//  LeveyPopListView.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "LeveyPopListView.h"
#import "LeveyPopListViewCell.h"
#import "RoundView.h"

#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define POPLISTVIEW_WIDTH 400.
#define POPLISTVIEW_HEIGHT 500.
#define RADIUS 5.

@interface LeveyPopListView (private)
- (void)fadeIn;
- (void)fadeOut;
@end

@implementation LeveyPopListView {
    UITableView *_tableView;
    NSString *_title;
    NSArray *_options;
    NSString * _headerImageName;
    float width;
    float height;
    float x;
    float y;
    NSMutableArray * selectedIndexes;
}

#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)sTitle options:(NSArray *)aOptions headerImage:(NSString *) sHeaderImageName
{
    _options=nil;
    self.CloseAfterSelect=YES;
    width = POPLISTVIEW_WIDTH;
    height = POPLISTVIEW_HEIGHT + POPLISTVIEW_SCREENINSET;
    x = POPLISTVIEW_SCREENINSET;
    y = POPLISTVIEW_SCREENINSET;
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _title = [sTitle copy];
        _headerImageName = [sHeaderImageName copy];
        _options = [aOptions copy];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x,
                                                                   y + POPLISTVIEW_HEADER_HEIGHT,
                                                                   width,
                                                                   height- POPLISTVIEW_SCREENINSET)];
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setAllowsMultipleSelection:YES];
        [self addSubview:_tableView];
    }
    return self;
}

-(id) initWithTitle:(NSString *)sTitle options:(NSArray *)aOptions headerImage:(NSString *)sHeaderImageName andHeight:(float)fHeight andWidth:(float)fWidth
{
    self.CloseAfterSelect=YES;
    width = POPLISTVIEW_WIDTH;
    height = POPLISTVIEW_HEIGHT + POPLISTVIEW_SCREENINSET;
    x = POPLISTVIEW_SCREENINSET;
    y = POPLISTVIEW_SCREENINSET;
    CGRect rect = CGRectMake(0, 0, fWidth, fHeight);
    
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        _title = [sTitle copy];
        _headerImageName = [sHeaderImageName copy];
        _options = [aOptions copy];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x,
                                                                   y + POPLISTVIEW_HEADER_HEIGHT,
                                                                   width,
                                                                   height)];
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setAllowsMultipleSelection:YES];
        [self addSubview:_tableView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)sTitle
            options:(NSArray *)aOptions headerImage:(NSString *) sHeaderImageName
            handler:(void (^)(NSInteger anIndex))aHandlerBlock {
    
    if(self = [self initWithTitle:sTitle options:aOptions headerImage:sHeaderImageName])
        self.handlerBlock = aHandlerBlock;
    
    return self;
}

-(void) setOptions:(NSArray *)optoins
{
    _options = optoins;
    [_tableView reloadData];
}

#pragma mark - Private Methods
- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [self removeFromSuperview];
    /*[UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];*/
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}


#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell)
        cell = [[LeveyPopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    
    if ([_options[indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
        cell.imageView.image = _options[indexPath.row][@"img"];
        cell.textLabel.text = _options[indexPath.row][@"text"];
    } else
        cell.textLabel.text = _options[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // tell the delegate the selection
    if (self.CloseAfterSelect)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([_delegate respondsToSelector:@selector(leveyPopListView:didSelectedIndex:)])
            [_delegate leveyPopListView:self didSelectedIndex:[indexPath row]];
        
        if (_handlerBlock)
            _handlerBlock(indexPath.row);
        // dismiss self
        [self fadeOut];
    }
    else
    {
        if (!selectedIndexes)
        {
            selectedIndexes = [[NSMutableArray alloc] init];
        }
        //Close the popup when the last item is selected, it should be the select or close item
        if (indexPath.row == _options.count-2 )
        {
            if ([_delegate respondsToSelector:@selector(leveyPopListViewSelectMultiple:didSelectedIndexes:)])
                [_delegate leveyPopListViewSelectMultiple:self didSelectedIndexes:[selectedIndexes copy]];
            [self fadeOut];
        }
        else if (indexPath.row == _options.count-1 )
        {
            [self Cancel];
        }
        else
        {
            [selectedIndexes addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
    }
}
#pragma mark - Touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // tell the delegate the cancellation
    [self Cancel];
}

-(void) Cancel
{
    if ([_delegate respondsToSelector:@selector(leveyPopListViewDidCancel)])
        [_delegate leveyPopListViewDidCancel];
    
    // dismiss self
    [self fadeOut];
    
}
#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    CGRect titleRect = CGRectMake(x + 10, y + 10 + 5,
                                  400, 30);
    CGRect separatorRect = CGRectMake(x, y + POPLISTVIEW_HEADER_HEIGHT - 2,400, 2);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithRed:13/255.0f green:90/255.0f blue:168/255.0f alpha:.75].CGColor);
    [[UIColor colorWithRed:13/255.0f green:90/255.0f blue:168/255.0f alpha:.75] setFill];
    float x1,y1,x2,y2;
    CGMutablePathRef path = CGPathCreateMutable();
    x1 = x;
    y1=y+RADIUS;
    CGPathMoveToPoint(path, NULL, x1, y1);
    x1=x;
    y1=y;
    x2=x + RADIUS;
    y2=y;
    CGPathAddArcToPoint(path, NULL, x1, y1,x2 , y2, RADIUS);
    x1=x + width;
    y1=y;
    x2=x + width;
    y2=y + RADIUS;
    CGPathAddArcToPoint(path, NULL, x1, y1,x2 , y2, RADIUS);
    x1=x + width;
    y1=y + height;
    x2=x + width - RADIUS;
    y2=y + height;
    CGPathAddArcToPoint(path, NULL, x1, y1,x2 , y2, RADIUS);
    x1=x;
    y1=y + height;
    x2=x;
    y2=y + height - RADIUS;
    CGPathAddArcToPoint(path, NULL, x1, y1,x2 , y2, RADIUS);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor whiteColor] setFill];
    [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:17.]];
    CGRect titleImageRect = CGRectMake(392, y + 10, 25, 25);
    [[UIImage imageNamed:_headerImageName] drawInRect:titleImageRect blendMode:nil alpha:0.5];
    CGContextFillRect(ctx, separatorRect);
    
}

@end

