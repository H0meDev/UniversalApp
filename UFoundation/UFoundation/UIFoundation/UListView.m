//
//  UListView.m
//  UFoundation
//
//  Created by Think on 15/11/26.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"
#import "UDefines.h"
#import "NSObject+UAExtension.h"
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

- (void)cellWillInvisible
{
    //
}

- (void)dealloc
{
    //
}

@end

@interface UListView ()
{
    NSInteger _numberOfCells;
    NSMutableArray *_valueArray; // Store height or width of cells
}

@property (atomic, strong) NSMutableDictionary *reusePool;
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
        
        _valueArray = [NSMutableArray array];
        _reusePool = [NSMutableDictionary dictionary];
        
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
        
        _valueArray = [NSMutableArray array];
        _reusePool = [NSMutableDictionary dictionary];
        
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
    
    // Clear subviews
    [scrollView removeAllSubviews];
    
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
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.contentSize = sizeMake(frame.size.width + 0.5, 0);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (_numberOfCells == -1) {
        [self reloadData];
    }
}

#pragma mark - Methods

- (NSRange)rangeOfVisibleIndexWith:(CGPoint)offset
{
    NSInteger beginIndex = 0;
    NSInteger endIndex = beginIndex;
    
    CGFloat deltaValue = 0;
    CGFloat offsetLValue = offset.x;
    CGFloat offsetTValue = offset.y;
    CGFloat offsetRValue = offset.x + self.scrollView.sizeWidth;
    CGFloat offsetBValue = offset.y + self.scrollView.sizeHeight;
    
    for (NSInteger index = 0; index < _valueArray.count; index ++) {
        CGFloat delta = deltaValue + [_valueArray[index] floatValue];
        
        // Left or top
        if (((deltaValue < offsetLValue) && (delta > offsetLValue)) ||
            ((deltaValue < offsetTValue) && (delta > offsetTValue)))
        {
            beginIndex = index;
        }
        
        // Right or bottom
        if (((deltaValue < offsetRValue) && (delta > offsetRValue)) ||
            ((deltaValue < offsetBValue) && (delta > offsetBValue)))
        {
            endIndex = index;
        }
        
        deltaValue = delta;
    }
    
    endIndex = (endIndex >= beginIndex)?endIndex:(_valueArray.count - 1);
    NSInteger location = beginIndex;
    NSInteger length = endIndex - beginIndex;
    
    NSLog(@"Range: %@ - %@", @(beginIndex), @(endIndex));
    
    return NSMakeRange(location, length);
}

- (BOOL)checkVisibleWith:(UListViewCell *)cell offset:(CGPoint)offset
{
    CGFloat width = self.scrollView.sizeWidth;
    CGFloat height = self.scrollView.sizeHeight;
    
    // Visible rect
    CGRect frame = rectMake(offset.x, offset.y, width, height);
    
    // To be detected
    CGPoint pointLT = pointMake(cell.left, cell.top);
    CGPoint pointLB = pointMake(cell.left, cell.bottom);
    CGPoint pointRT = pointMake(cell.right, cell.top);
    CGPoint pointRB = pointMake(cell.right, cell.bottom);
    
    return (CGRectContainsPoint(frame, pointLT) ||
            CGRectContainsPoint(frame, pointLB) ||
            CGRectContainsPoint(frame, pointRT) ||
            CGRectContainsPoint(frame, pointRB));
}

- (BOOL)checkLTBoundWith:(UListViewCell *)cell offset:(CGPoint)offset
{
    CGFloat height = self.scrollView.sizeHeight;
    CGPoint pointLT = pointMake(offset.x, 0);
    CGPoint pointLB = pointMake(offset.x, height);
    
    return (CGRectContainsPoint(cell.frame, pointLT) || CGRectContainsPoint(cell.frame, pointLB));
}

- (BOOL)checkRBBoundWith:(UListViewCell *)cell offset:(CGPoint)offset
{
    CGFloat width = self.scrollView.sizeWidth;
    CGFloat height = self.scrollView.sizeHeight;
    CGPoint pointRT = pointMake(offset.x + width, 0);
    CGPoint pointRB = pointMake(offset.x + width, height);
    
    return (CGRectContainsPoint(cell.frame, pointRT) || CGRectContainsPoint(cell.frame, pointRB));
}

- (void)reuseCell:(UListViewCell *)cell forIdentifier:(NSString *)identifier
{
    if (!checkValidNSString(identifier)) {
        return;
    }
    
    NSArray *array = _reusePool[identifier];
    NSMutableArray *marray = (!array)?[NSMutableArray array]:[NSMutableArray arrayWithArray:array];
    [marray addObject:cell];
    [_reusePool setObject:[marray copy] forKey:identifier];
}

- (UListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    UListViewCell *cell = nil;
    for (UListViewCell *item in self.scrollView.subviews) {
        if (item.superview == nil) {
            cell = item;
            
            break;
        }
    }
    
    return cell;
}

- (void)dequeueCellsWithOffset
{
    [self dequeueCellsWith:self.scrollView.contentOffset];
}

- (void)dequeueCellsWith:(CGPoint)offset
{
    CGSize size = self.scrollView.contentSize;
    CGFloat offsetMaxX =  size.width - self.scrollView.sizeWidth;
    
    offset.x = (offset.x < 0)?0:offset.x;
    offset.x = (offset.x > offsetMaxX)?offsetMaxX:offset.x;
    
    if (_style == UListViewStyleVertical) {
        //
    } else if (_style == UListViewStyleHorizontal) {
        // All added cells
        NSMutableArray *subviews = [NSMutableArray array];
        for (UIView *view in self.scrollView.subviews) {
            if (checkClass(view, UListViewCell)) {
                [subviews addObject:view];
            }
        }
        
        // Remove invisible cells
        NSArray *viewArray = [NSArray arrayWithArray:subviews];
        for (UListViewCell *cell in viewArray) {
            if (cell.superview && ![self checkVisibleWith:cell offset:offset]) {
                [cell removeFromSuperview];
                [subviews removeObject:cell];
                
                // For invisible option
                [cell cellWillInvisible];
            }
        }
        
        // Range of current
        NSRange range = [self rangeOfVisibleIndexWith:offset];
        NSInteger count = range.length + 1;
        NSInteger beginIndex = range.location;
        NSInteger endIndex = range.location + range.length;
        
        // Check needs dequeue or not
        if (subviews.count > 0) {
            if (endIndex > beginIndex) {
                // Check left or top
                UListViewCell *cell = (UListViewCell *)[subviews firstObject];
                CGFloat originX = cell.left;
                
                if (![self checkLTBoundWith:cell offset:offset]) {
                    CGFloat width = [_valueArray[beginIndex] floatValue];
                    originX = originX - width;
                    
                    UListViewCell *cellItem = nil;
                    if (count > subviews.count) {
                        cellItem = [self.dataSource listView:self.weakself cellAtIndex:beginIndex];
                        cellItem.frame = rectMake(originX, 0, width, self.scrollView.sizeHeight);
                    } else if (beginIndex > 0) {
                        cellItem = [self.dataSource listView:self.weakself cellAtIndex:beginIndex - 1];
                        cellItem.frame = rectMake(originX, 0, width, self.scrollView.sizeHeight);
                    }
                    
                    if (cellItem) {
                        // Insert into first
                        [self.scrollView addSubview:cellItem];
                        [self.scrollView insertSubview:cellItem belowSubview:cell];
                        
                        // Refresh subviews
                        [subviews removeAllObjects];
                        for (UIView *view in self.scrollView.subviews) {
                            if (checkClass(view, UListViewCell)) {
                                [subviews addObject:view];
                            }
                        }
                    }
                }
                
                // Check right or bottom
                cell = (UListViewCell *)[subviews lastObject];
                originX = cell.right;
                
                if (![self checkRBBoundWith:cell offset:offset]) {
                    CGFloat width = [_valueArray[endIndex] floatValue];
                    UListViewCell *cellItem = nil;
                    
                    if (count > subviews.count) {
                        cellItem = [self.dataSource listView:self.weakself cellAtIndex:endIndex];
                        cellItem.frame = rectMake(originX, 0, width, self.scrollView.sizeHeight);
                    } else if ((endIndex + 1) < _numberOfCells) {
                        cellItem = [self.dataSource listView:self.weakself cellAtIndex:endIndex + 1];
                        cellItem.frame = rectMake(originX, 0, width, self.scrollView.sizeHeight);
                    }
                    
                    if (cellItem) {
                        [self.scrollView addSubview:cellItem];
                        [self.scrollView insertSubview:cellItem aboveSubview:cell];
                    }
                }
            }
        } else if (_valueArray.count > count) {
            CGFloat originX = 0;
            for (NSInteger index = 0; index < beginIndex + count; index ++) {
                if (index < beginIndex) {
                    originX += [_valueArray[index] floatValue];
                } else {
                    CGFloat value = [_valueArray[index] floatValue];
                    UListViewCell *cell = [self.dataSource listView:self.weakself cellAtIndex:index];
                    cell.frame = rectMake(originX, 0, value, self.sizeHeight);
                    [self.scrollView addSubview:cell];
                    
                    UIView *lastView = (UIView *)[self.scrollView.subviews lastObject];
                    [self.scrollView insertSubview:cell aboveSubview:lastView];
                    
                    originX +=  value;
                }
            }
        }
    }
}

- (void)reloadData
{
    NSArray *subviews = [NSArray arrayWithArray:self.scrollView.subviews];
    for (UListViewCell *cell in subviews) {
        if (checkClass(cell, UListViewCell)) {
            [cell removeFromSuperview];
            
            // For invisible option
            [cell cellWillInvisible];
        }
    }
    
    _numberOfCells = [self.dataSource numberOfRowInListView:self.weakself];
    
    CGFloat sizeValue = 0;
    for (NSInteger index = 0; index < _numberOfCells; index ++) {
        CGFloat value = [self.delegate listView:self.weakself heightOrWidthForIndex:index];
        [_valueArray addObject:@(value)];
        
        sizeValue += value;
    }
    
    self.scrollView.contentSize = sizeMake(sizeValue, 0);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Dequeue all cells
        [self performOnMainThread:@selector(dequeueCellsWithOffset)];
    }
}

@end
