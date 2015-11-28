//
//  UListView.m
//  UFoundation
//
//  Created by Think on 15/11/26.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"
#import "UDefines.h"
#import "UIView+UAExtension.h"

@implementation UListViewCell

+ (id)cell
{
    @autoreleasepool
    {
        return [[self alloc]init];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    
    return self;
}

- (void)dealloc
{
    //
}

@end

@interface UListView ()
{
    NSInteger _numberOfCells;
}

@property (atomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation UListView

@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = UListViewStyleVertical;
        _numberOfCells = -1;
        _cellArray = [NSMutableArray array];
        
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = sysWhiteColor();
    }
    
    return self;
}

- (id)initWithStyle:(UListViewStyle)style
{
    return [self initWithFrame:CGRectZero style:style];
}

- (id)initWithFrame:(CGRect)frame style:(UListViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        _numberOfCells = -1;
        _cellArray = [NSMutableArray array];
        
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = sysWhiteColor();
    }
    
    return self;
}

- (void)dealloc
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (UIScrollView *)scrollView
{
    if (_scrollView) {
        return _scrollView;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = sysClearColor();
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    // KVO
    [scrollView addObserver:self
                 forKeyPath:@"contentOffset"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:NULL];
    
    return _scrollView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // Resize scrollView
    self.scrollView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
    
    if (_style == UListViewStyleVertical) {
        self.scrollView.showsVerticalScrollIndicator = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = sizeMake(0, frame.size.height + 0.5);
    } else if (_style == UListViewStyleHorizontal) {
        self.scrollView.showsVerticalScrollIndicator = YES;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.contentSize = sizeMake(frame.size.width + 0.5, 0);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (_numberOfCells == -1) {
        _numberOfCells = [self.dataSource numberOfRowInListView:self];
    }
    
    dispatch_async(main_queue(), ^{
        if (!checkValidNSArray(_cellArray)) {
            CGFloat startValue = 0;
            for (int i = 0; i < _numberOfCells; i ++) {
                @autoreleasepool
                {
                    CGFloat heightOrWidth = [self.delegate listView:self heightOrWidthForIndex:i];
                    UListViewCell *cell = [self.dataSource listView:self cellAtIndex:i];
                    cell.frame = rectMake(startValue, 0, heightOrWidth, self.sizeHeight);
                    [self.scrollView addSubview:cell];
                    
                    startValue += heightOrWidth;
                }
            }
            
            self.scrollView.contentSize = sizeMake(startValue, 0);
        }
    });
}

#pragma mark - Methods

- (void)reuseCell:(UListViewCell *)cell forIdentifier:(NSString *)identifier
{
    [_cellArray addObject:cell];
}

- (UListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    UListViewCell *cell = nil;
    for (UListViewCell *item in _cellArray) {
        if (item.superview == nil) {
            cell = item;
            
            break;
        }
    }
    
    return cell;
}

- (void)dequeueCellsWith:(CGPoint)offset
{
    for (UListViewCell *cell in _cellArray) {
        if (cell.window == nil) {
            [cell removeFromSuperview];
        }
    }
    
    if (_style == UListViewStyleVertical) {
        //
    } else if (_style == UListViewStyleHorizontal) {
        //
    }
}

- (void)reloadData
{
    //
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[@"new"] CGPointValue];
        
        // Dequeue all cells
        dispatch_async(main_queue(), ^{
            [self dequeueCellsWith:offset];
        });
    }
}

@end
