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
#import "UIScrollView+UAExtension.h"

@interface UListViewCell () <URefreshViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@end

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

- (void)cellWillAppear
{
    //
}

- (void)cellDidDisappear
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
    NSLock *_dequeueLock;
    NSInteger _numberOfCells;
    NSMutableArray *_valueArray;
    NSMutableDictionary *_cellReusePool;
}

// For cells
@property (nonatomic, strong) UIView *contentView;

@end

@implementation UListView

@synthesize style = _style;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = UListViewStyleVertical;
        _numberOfCells = -1;
        _spaceValue = 0;
        
        _dequeueLock = [[NSLock alloc]init];
        _valueArray = [NSMutableArray array];
        _cellReusePool = [NSMutableDictionary dictionary];
        
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
        _spaceValue = 0;
        
        _dequeueLock = [[NSLock alloc]init];
        _valueArray = [NSMutableArray array];
        _cellReusePool = [NSMutableDictionary dictionary];
        
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = sysWhiteColor();
    }
    
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (_numberOfCells == -1) {
        [self reloadData];
    }
}

- (void)dealloc
{
    [_valueArray removeAllObjects];
    [_cellReusePool removeAllObjects];
    
    _valueArray = nil;
    _cellReusePool = nil;
    
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        
        // Remove header & footer
        [_contentView removeAllSubviews];
        [_scrollView removeAllSubviews];
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
    UIView *contentView = [[UIView alloc]init];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = sysClearColor();
    [scrollView addSubview:contentView];
    _contentView = contentView;
    
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
        self.contentView.frame = rectMake(0, 0, frame.size.width, frame.size.height + 0.5);
    } else if (_style == UListViewStyleHorizontal) {
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.contentSize = sizeMake(frame.size.width + 0.5, 0);
        self.contentView.frame = rectMake(0, 0, frame.size.width + 0.5, frame.size.height);
    }
}

- (void)setSpaceValue:(CGFloat)value
{
    _spaceValue = (value < 0)?0:value;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Dequeue all cells
        [self performOnMainThread:@selector(dequeueCellsWith:) with:change[@"new"]];
    }
}

#pragma mark - Methods

- (void)dequeueCellsWith:(NSValue *)value
{
    [_dequeueLock lock];
    
    CGPoint offset = [value CGPointValue];
    CGRange range = [self visibleRangeWith:offset];
    NSInteger beginIndex = range.min;
    NSInteger endIndex = range.max;
    
    for (NSInteger i = beginIndex; i <= endIndex; i ++) {
        @autoreleasepool
        {
            NSArray *cells = [self currentVisibleCellsWith:offset];
            
            BOOL needsAttached = NO;
            if ((i - beginIndex) <= cells.count) {
                needsAttached = ![self checkCellWith:i from:cells];
            } else {
                needsAttached = YES;
            }
            
            if (needsAttached) {
                // Attach cell
                CGFloat sizeValue = [_valueArray[i] floatValue];
                CGFloat originValue = [self originValueOfIndex:i];
                
                UListViewCell *cell = [self.dataSource listView:self.weakself cellAtIndex:i];
                if (_style == UListViewStyleHorizontal) {
                    cell.frame = rectMake(originValue, 0, sizeValue, self.scrollView.sizeHeight);
                } else if (_style == UListViewStyleVertical) {
                    cell.frame = rectMake(0, originValue, self.scrollView.sizeWidth, sizeValue);
                }
                
                // For visible option
                [cell cellWillAppear];
                
                // Attached to scrollView
                [self.contentView addSubview:cell];
            }
        }
    }
    
    [_dequeueLock unlock];
}

- (CGRange)visibleRangeWith:(CGPoint)offset
{
    CGFloat deltaValue = 0;
    CGFloat offsetLValue = offset.x;
    CGFloat offsetTValue = offset.y;
    CGFloat offsetRValue = offset.x + self.scrollView.sizeWidth;
    CGFloat offsetBValue = offset.y + self.scrollView.sizeHeight;
    
    NSInteger beginIndex = -1;
    NSInteger endIndex = 0;
    
    for (NSInteger index = 0; index < _valueArray.count; index ++) {
        CGFloat minValue = deltaValue + _spaceValue * index;
        CGFloat maxValue = minValue + [_valueArray[index] floatValue];
        
        // Begin, pick the first suitable index
        if (beginIndex == -1) {
            if (_style == UListViewStyleHorizontal) {
                if (maxValue >= offsetLValue) {
                    beginIndex = index;
                }
            } else if (_style == UListViewStyleVertical) {
                if (maxValue >= offsetTValue) {
                    beginIndex = index;
                }
            }
        }
        
        // End, pick the last suitable index
        if (_style == UListViewStyleHorizontal) {
            if ((maxValue <= offsetRValue) || (minValue <= offsetRValue && maxValue >= offsetRValue)) {
                endIndex = index;
            }
        } else if (_style == UListViewStyleVertical) {
            if ((maxValue <= offsetBValue) || (minValue <= offsetBValue && maxValue >= offsetBValue)) {
                endIndex = index;
            }
        }
        
        deltaValue += [_valueArray[index] floatValue];
    }
    
    NSLog(@"%@ - %@", @(beginIndex), @(endIndex));
    
    return CGRangeMake((beginIndex < 0)?0:beginIndex, endIndex);
}

- (NSArray *)currentVisibleCellsWith:(CGPoint)offset
{
    // All added cells
    NSMutableArray *subviews = [NSMutableArray array];
    for (UListViewCell *cell in self.contentView.subviews) {
        if (![self checkVisibleWith:cell offset:offset]) {
            if (cell.superview) {
                // Remove
                [cell removeFromSuperview];
                
                // For invisible option
                [cell cellDidDisappear];
            }
        } else {
            [subviews addObject:cell];
        }
    }
    
    return subviews;
}

- (BOOL)checkVisibleWith:(UListViewCell *)cell offset:(CGPoint)offset
{
    if (!cell) {
        return NO;
    }
    
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

- (CGFloat)originValueOfIndex:(NSInteger)index
{
    index = (index < 0)?0:index;
    index = (index > _numberOfCells)?_numberOfCells - 1:index;
    
    CGFloat value = 0;
    for (NSInteger i = 0; i < _valueArray.count; i ++) {
        if (index == i) {
            break;
        }
        
        value += [_valueArray[i] floatValue] + _spaceValue;
    }
    
    return value;
}

- (BOOL)checkCellWith:(NSInteger)index from:(NSArray *)cells
{
    BOOL contains = NO;
    
    if (checkValidNSArray(cells)) {
        CGFloat originValue = [self originValueOfIndex:index];
        for (UListViewCell *cell in cells) {
            if (_style == UListViewStyleHorizontal) {
                if (cell.originX == originValue) {
                    contains = YES;
                    break;
                }
            } else if (_style == UListViewStyleVertical) {
                if (cell.originY == originValue) {
                    contains = YES;
                    break;
                }
            }
        }
    }
    
    return contains;
}

#pragma mark - Outer Methods

- (void)registerCell:(NSString *)cellName forIdentifier:(NSString *)identifier
{
    if (!checkValidNSString(cellName) || !checkValidNSString(identifier)) {
        return;
    }
    
    Class class = NSClassFromString(cellName);
    if (class) {
        NSArray *array = _cellReusePool[identifier];
        NSMutableArray *marray = (!array)?[NSMutableArray array]:[NSMutableArray arrayWithArray:array];
        [marray addObject:[class cell]];
        [_cellReusePool setObject:[marray copy] forKey:identifier];
    }
}

- (UListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    UListViewCell *cell = nil;
    
    if (checkValidNSString(identifier)) {
        NSArray *cells = _cellReusePool[identifier];
        if (checkValidNSArray(cells)) {
            // Only one unattached cell leaves
            for (UListViewCell *cellItem in cells) {
                if (cellItem.superview == nil) {
                    cell = cellItem;
                    break;
                }
            }
        }
    }
    
    return cell;
}

- (void)reloadData
{
    // Remove all cells
    for (UListViewCell *cell in self.contentView.subviews) {
        if (cell.superview) {
            // Remove
            [cell removeFromSuperview];
            
            // For invisible option
            [cell cellDidDisappear];
        }
    }
    
    // Reset all cache
    [_valueArray removeAllObjects];
    [_cellReusePool removeAllObjects];
    _numberOfCells = [self.dataSource numberOfItemsInListView:self.weakself];
    
    CGFloat sizeValue = 0;
    for (NSInteger index = 0; index < _numberOfCells; index ++) {
        CGFloat value = [self.delegate listView:self.weakself heightOrWidthForIndex:index];
        [_valueArray addObject:@(value)];
        
        if (index == (_numberOfCells - 1)) {
            sizeValue += value;
        } else {
            sizeValue += value + _spaceValue;
        }
    }
    
    if (_style == UListViewStyleHorizontal) {
        self.contentView.sizeWidth = sizeValue;
        self.scrollView.contentSize = sizeMake(sizeValue, 0);
    } else if (_style == UListViewStyleVertical) {
        self.contentView.sizeHeight = sizeValue;
        self.scrollView.contentSize = sizeMake(0, sizeValue);
    }
    
    // Load cells
    self.scrollView.contentOffset = CGPointZero;
}

@end
