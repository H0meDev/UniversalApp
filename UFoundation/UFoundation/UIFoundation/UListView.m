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

@interface UListViewCellItem : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat sizeValue;   // Value of size
@property (nonatomic, assign) CGFloat originValue; // Value of origin

+ (id)item;

@end

@implementation UListViewCellItem

+ (id)item
{
    @autoreleasepool
    {
        return [[self alloc]init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _sizeValue = 0;
        _originValue = 0;
    }
    
    return self;
}

@end

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
        // Initalize
    }
    
    return self;
}

- (UIView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = sysWhiteColor();
    [super addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.contentView.frame = self.bounds;
}

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:sysClearColor()];
    
    self.contentView.backgroundColor = color;
}

- (void)addSubview:(UIView *)view
{
    [self.contentView addSubview:view];
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
    NSArray *_itemArray; // Array of UListViewCellItem
    NSMutableDictionary *_cellReusePool;
    CGRange _currentRange;
}

// For cells
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation UListView

@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = UListViewStyleVertical;
        
        _spaceValue = 0;
        _headerValue = 0;
        _footerValue = 0;
        _currentRange.min = -1;
        _currentRange.max = -1;
        
        _dequeueLock = [[NSLock alloc]init];
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
    self = [self initWithFrame:frame];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
        
        // Reload cells
        [self reloadData];
    }
}

- (void)dealloc
{
    [_cellReusePool removeAllObjects];
    
    _itemArray = nil;
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
    
    // Content
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
    
    // Reset all
    [self reloadData];
}

- (void)setHeaderValue:(CGFloat)value
{
    _headerValue = value;
    
    // Reset all
    [self reloadData];
}

- (void)setFooterValue:(CGFloat)value
{
    _footerValue = value;
    
    // Reset all
    [self reloadData];
}

- (void)setHeaderView:(UIView *)headerView
{
    _headerView = headerView;
    
    // Reset all
    [self reloadData];
}

- (void)setFooterView:(UIView *)footerView
{
    _footerView = footerView;
    
    // Reset all
    [self reloadData];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Dequeue all views
        [self dequeueAllViewsWith:[change[@"new"] CGPointValue]];
    }
}

#pragma mark - Methods

- (void)dequeueAllViewsWith:(CGPoint)offset
{
    [_dequeueLock lock];
    
    // Visible cells
    [self dequeueCellsWith:offset];
    
    // Headers & Footers
    [self dequeueHeadersWith:offset];
    [self dequeueFootersWith:offset];
    
    [_dequeueLock unlock];
}

- (void)dequeueHeadersWith:(CGPoint)offset
{
    if (_headerView) {
        if (_style == UListViewStyleHorizontal) {
            //
        } else if (_style == UListViewStyleVertical) {
            //
        }
    }
}

- (void)dequeueFootersWith:(CGPoint)offset
{
    if (_footerView) {
        if (_style == UListViewStyleHorizontal) {
            //
        } else if (_style == UListViewStyleVertical) {
            //
        }
    }
}

- (void)dequeueCellsWith:(CGPoint)offset
{
    if (_itemArray) {
        CGRange range = [self visibleRangeWith:offset];
        if (_currentRange.min == range.min && _currentRange.max == range.max) {
            return;
        }
        
        _currentRange.min = range.min;
        _currentRange.max = range.max;
        
        NSInteger beginIndex = range.min;
        NSInteger endIndex = range.max;
        
        if (_itemArray.count > endIndex) {
            for (NSInteger index = beginIndex; index <= endIndex; index ++) {
                @autoreleasepool
                {
                    NSArray *cells = [self currentVisibleCellsWith:offset];
                    
                    BOOL needsAttached = NO;
                    if ((index - beginIndex) <= cells.count) {
                        needsAttached = ![self checkCellWith:index from:cells];
                    } else {
                        needsAttached = YES;
                    }
                    
                    if (needsAttached) {
                        // Attach cell
                        UListViewCellItem *item = _itemArray[index];
                        UListViewCell *cell = [self.dataSource listView:self.weakself cellAtIndex:index];
                        
                        if (_style == UListViewStyleHorizontal) {
                            cell.frame = rectMake(item.originValue, 0, item.sizeValue, self.scrollView.sizeHeight);
                        } else if (_style == UListViewStyleVertical) {
                            cell.frame = rectMake(0, item.originValue, self.scrollView.sizeWidth, item.sizeValue);
                        }
                        
                        // For visible option
                        [cell cellWillAppear];
                        
                        // Attached to scrollView
                        [self.contentView addSubview:cell];
                    }
                }
            }
        }
        
        // Remove unused cells
        [self removeUnusedCells];
    }
}

- (CGRange)visibleRangeWith:(CGPoint)offset
{
    NSInteger beginIndex = -1;
    NSInteger endIndex = 0;
    
    if (_itemArray) {
        CGFloat offsetLValue = offset.x;
        CGFloat offsetTValue = offset.y;
        CGFloat offsetRValue = offset.x + self.scrollView.sizeWidth;
        CGFloat offsetBValue = offset.y + self.scrollView.sizeHeight;
        
        for (NSInteger index = 0; index < _itemArray.count; index ++) {
            UListViewCellItem *item = _itemArray[index];
            CGFloat minValue = item.originValue;
            CGFloat maxValue = item.originValue + item.sizeValue;
            
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
                } else {
                    break;
                }
            } else if (_style == UListViewStyleVertical) {
                if ((maxValue <= offsetBValue) || (minValue <= offsetBValue && maxValue >= offsetBValue)) {
                    endIndex = index;
                } else {
                    break;
                }
            }
        }
    }
    
    return CGRangeMake((beginIndex < 0)?0:beginIndex, endIndex);
}

- (NSArray *)currentVisibleCellsWith:(CGPoint)offset
{
    // All added cells
    NSMutableArray *subviews = [NSMutableArray array];
    for (UListViewCell *cell in self.contentView.subviews) {
        if (checkClass(cell, UListViewCell) && ![self checkVisibleWith:cell offset:offset]) {
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

- (BOOL)checkVisibleWith:(UIView *)view offset:(CGPoint)offset
{
    if (!checkClass(view, UIView)) {
        return NO;
    }
    
    CGFloat width = self.scrollView.sizeWidth;
    CGFloat height = self.scrollView.sizeHeight;
    
    // Visible rect
    CGRect frame = rectMake(offset.x, offset.y, width, height);
    
    // To be detected
    CGPoint pointLT = pointMake(view.left, view.top);
    CGPoint pointLB = pointMake(view.left, view.bottom);
    CGPoint pointRT = pointMake(view.right, view.top);
    CGPoint pointRB = pointMake(view.right, view.bottom);
    
    return (CGRectContainsPoint(frame, pointLT) ||
            CGRectContainsPoint(frame, pointLB) ||
            CGRectContainsPoint(frame, pointRT) ||
            CGRectContainsPoint(frame, pointRB));
}

- (BOOL)checkCellWith:(NSInteger)index from:(NSArray *)cells
{
    BOOL contains = NO;
    
    if (checkValidNSArray(cells)) {
        UListViewCellItem *item = _itemArray[index];
        for (UListViewCell *cell in cells) {
            if (_style == UListViewStyleHorizontal) {
                if (cell.originX == item.originValue) {
                    contains = YES;
                    break;
                }
            } else if (_style == UListViewStyleVertical) {
                if (cell.originY == item.originValue) {
                    contains = YES;
                    break;
                }
            }
        }
    }
    
    return contains;
}

- (void)removeUnusedCells
{
    for (NSString *key in _cellReusePool) {
        NSArray *cells = _cellReusePool[key];
        if (checkValidNSArray(cells)) {
            NSMutableArray *marray = [NSMutableArray arrayWithArray:cells];
            for (UListViewCell *cell in cells) {
                if (cell.superview == nil) {
                    [marray removeObject:cell];
                }
            }
            
            // Refresh
            [_cellReusePool setObject:marray forKey:key];
        }
    }
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
    if (_itemArray == nil) {
        return;
    }
    
    // Remove all cells
    for (UListViewCell *cell in self.contentView.subviews) {
        if (checkClass(cell, UListViewCell) && cell.superview) {
            // Remove
            [cell removeFromSuperview];
            
            // For invisible option
            [cell cellDidDisappear];
        }
    }
    
    // Reset all cache
    _itemArray = nil;
    [_cellReusePool removeAllObjects];
    
    CGFloat originValue = _headerValue; // Header
    NSInteger count = [self.dataSource numberOfItemsInListView:self.weakself];
    NSMutableArray *marray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < count; index ++) {
        CGFloat sizeValue = [self.delegate listView:self.weakself sizeValueForIndex:index];
        sizeValue = [@(sizeValue) floatValue];
        originValue = [@(originValue) floatValue];
        
        // To store item
        UListViewCellItem *item = [UListViewCellItem item];
        item.index = index;
        item.sizeValue = sizeValue;
        item.originValue = originValue;
        [marray addObject:item];
        
        if (index == (count - 1)) {
            originValue += sizeValue;
        } else {
            originValue += sizeValue + _spaceValue;
        }
    }
    
    _itemArray = marray;
    originValue += _footerValue; // Footer
    
    // Resize
    if (_style == UListViewStyleHorizontal) {
        self.contentView.sizeWidth = originValue;
        self.scrollView.contentSize = sizeMake(originValue, 0);
    } else if (_style == UListViewStyleVertical) {
        self.contentView.sizeHeight = originValue;
        self.scrollView.contentSize = sizeMake(0, originValue);
    }
    
    // Load cells
    self.scrollView.contentOffset = CGPointZero;
}

@end
