//
//  UListView.m
//  UFoundation
//
//  Created by Think on 15/11/26.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"
#import "UDefines.h"

@implementation UListViewCell

+ (id)cell
{
    @autoreleasepool
    {
        return [[self alloc]init];
    }
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
    scrollView.backgroundColor = sysLightGrayColor();
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
    [super willMoveToWindow:newWindow];
    
    if (_numberOfCells == -1) {
        _numberOfCells = [self.dataSource numberOfRowInListView:self];
    }
}

#pragma mark - Methods

- (void)reuseCell:(UListViewCell *)cell forIdentifier:(NSString *)identifier
{
    if (checkClass(cell, UListViewCell) && checkValidNSString(identifier)) {
        [self.cellArray addObject:cell];
    }
}

- (UListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [UListViewCell cell];
}

- (void)dequeueCellsWith:(CGPoint)offset
{
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
