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

#pragma mark - UListViewCellItem class

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

#pragma mark - UListViewCellContentView class

@interface UListViewCellContentView : UIControl
{
    BOOL _selected;
    __weak id _target;
    SEL _action;
}

@property (nonatomic, strong) UIView *backgroundMaskView;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, assign) BOOL cancelable;

- (void)setTarget:(id)target action:(SEL)action;

@end

@implementation UListViewCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _highlightedColor = [sysLightGrayColor() colorWithAlpha:0.35];
    }
    
    return self;
}

#pragma mark - Properties

- (UIView *)backgroundMaskView
{
    if (_backgroundMaskView) {
        return _backgroundMaskView;
    }
    
    UIView *backgroundMaskView = [[UIView alloc]init];
    backgroundMaskView.backgroundColor = sysClearColor();
    backgroundMaskView.userInteractionEnabled = NO;
    backgroundMaskView = backgroundMaskView;
    [self addSubview:backgroundMaskView];
    _backgroundMaskView = backgroundMaskView;
    
    return _backgroundMaskView;
}

#pragma mark - Methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backgroundMaskView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setTarget:(id)target action:(SEL)action
{
    if (_target && _action) {
        [self removeTarget:target action:action forControlEvents:UIControlEventTouchDown];
    }
    
    _target = target;
    _action = action;
    
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

#pragma mark - Event callback

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_cancelable) {
        self.selected = !_selected;
    } else {
        self.selected = YES;
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!_selected) {
        self.backgroundMaskView.backgroundColor = sysClearColor();
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    if (!_selected) {
        self.backgroundMaskView.backgroundColor = sysClearColor();
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _selected = selected;
    if (_selected) {
        self.backgroundMaskView.backgroundColor = _highlightedColor;
    } else {
        self.backgroundMaskView.backgroundColor = sysClearColor();
    }
}

@end

#pragma mark - UListViewCell class

@interface UListViewCell () <URefreshViewDelegate>
{
    __weak id _target;
    SEL _action;
    BOOL _selected;
}

@property (nonatomic, strong) UListViewCellContentView *contentView;
@property (nonatomic, strong) UIImageView *headerLineView;
@property (nonatomic, strong) UIImageView *footerLineView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL cancelable;

- (void)setTarget:(id)target action:(SEL)action;

@end

@implementation UListViewCell

@synthesize style = _style;

+ (id)cell
{
    return [[self alloc]initWithFrame:CGRectZero];
}

- (id)initWith:(UListViewStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initalize
        self.backgroundColor = sysClearColor();
        self.userInteractionEnabled = YES;
        
        _style = style;
        
        [self cellDidLoad];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initalize
        _style = UListViewStyleVertical;
        
        [self cellDidLoad];
    }
    
    return self;
}

#pragma mark - Properties

- (UListViewCellContentView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UListViewCellContentView *contentView = [[UListViewCellContentView alloc]init];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = sysWhiteColor();
    [contentView setTarget:self action:@selector(touchDownAction)];
    [super addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

- (UIImageView *)headerLineView
{
    if (_headerLineView) {
        return _headerLineView;
    }
    
    UIImageView *headerLineView = [[UIImageView alloc]init];
    headerLineView.backgroundColor = [sysBlackColor() colorWithAlpha:0.2];
    [self.contentView addSubview:headerLineView];
    _headerLineView = headerLineView;
    
    return _headerLineView;
}

- (UIImageView *)footerLineView
{
    if (_footerLineView) {
        return _footerLineView;
    }
    
    UIImageView *footerLineView = [[UIImageView alloc]init];
    footerLineView.backgroundColor = [sysBlackColor() colorWithAlpha:0.2];
    [self.contentView addSubview:footerLineView];
    _footerLineView = footerLineView;
    
    return _footerLineView;
}

- (BOOL)cancelable
{
    return self.contentView.cancelable;
}

- (BOOL)selected
{
    return self.contentView.selected;
}

#pragma mark - Methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        CGFloat headerValue = 0.5;
        CGFloat footerValue = 0.5;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        self.contentView.frame = rectMake(0, 0, width, height);
        if (_style == UListViewStyleVertical) {
            self.headerLineView.frame = rectMake(0, 0, width, headerValue);
            self.footerLineView.frame = rectMake(0, height - footerValue, width, footerValue);
        } else if (_style == UListViewStyleHorizontal) {
            self.headerLineView.frame = rectMake(0, 0, headerValue, height);
            self.footerLineView.frame = rectMake(width - footerValue, 0, footerValue, height);
        }
    }
}

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:sysClearColor()];
    
    self.contentView.backgroundColor = color;
}

- (void)setHighlightedColor:(UIColor *)color
{
    _highlightedColor = color;
    
    self.contentView.highlightedColor = color;
}

- (void)setCancelable:(BOOL)cancelable
{
    self.contentView.cancelable = cancelable;
}

- (void)addSubview:(UIView *)view
{
    [self.contentView addSubview:view];
}

- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)cellDidLoad
{
    //
}

- (void)cellWillAppear
{
    //
}

- (void)cellDidDisappear
{
    //
}

- (void)cellDidSelected
{
    //
}

- (void)cellDidDeselected
{
    //
}

- (void)dealloc
{
    //
}

#pragma mark - Actions

- (void)touchDownAction
{
    _selected = !_selected;
    if (_selected) {
        [self cellDidSelected];
    } else {
        [self cellDidDeselected];
    }
    
    if (_target && _action) {
        [_target performWithName:NSStringFromSelector(_action) with:self];
    }
}

@end

#pragma mark - UListView class

@interface UListView ()
{
    NSLock *_dequeueLock;
    NSArray *_itemArray; // Array of UListViewCellItem
    NSMutableDictionary *_cellReusePool;
    CGRange _currentRange;
}

// For cells
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation UListView

@synthesize style = _style;
@synthesize selectedIndexs = _selectedIndexs;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = UListViewStyleVertical;
        _separatorStyle = UListViewCellSepratorLineStyleNoEnds;
        
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

- (id)initWith:(UListViewStyle)style
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
    
    if (_style == UListViewStyleVertical) {
        self.scrollView.showsVerticalScrollIndicator = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = sizeMake(0, frame.size.height);
    } else if (_style == UListViewStyleHorizontal) {
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.contentSize = sizeMake(frame.size.width, 0);
    }
    
    // Resize
    self.scrollView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
    self.contentView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
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

- (void)setSeparatorStyle:(UListViewCellSepratorLineStyle)style
{
    _separatorStyle = style;
    
    // Reset all
    [self reloadData];
}

- (void)setCancelable:(BOOL)cancelable
{
    _cancelable = cancelable;
    
    // Reset all
    [self reloadData];
}

- (NSArray *)selectedIndexs
{
    // Sort
    _selectedIndexs = [_selectedIndexs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedAscending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    return _selectedIndexs;
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
    
    [_dequeueLock unlock];
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
                        UListViewCell *cell = [self cellAtIndex:index];
                        
                        if (_style == UListViewStyleHorizontal) {
                            cell.frame = rectMake(item.originValue, 0, item.sizeValue, self.scrollView.sizeHeight);
                        } else if (_style == UListViewStyleVertical) {
                            cell.frame = rectMake(0, item.originValue, self.scrollView.sizeWidth, item.sizeValue);
                        }
                        
                        // For visible option
                        [cell cellWillAppear];
                        
                        // Reset cell seprator line
                        [self resetSepratorWith:cell index:index];
                        
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

- (UListViewCell *)cellAtIndex:(NSInteger)index
{
    UListViewCell *cell = [self.dataSource listView:self.weakself cellAtIndex:index];
    
    // For selection
    cell.index = index;
    cell.cancelable = self.cancelable;
    cell.contentView.selected = NO;
    [cell setTarget:self action:@selector(cellTouchedDownAction:)];
    
    for (NSNumber *indexValue in _selectedIndexs) {
        if ([indexValue integerValue] == index) {
            cell.contentView.selected = YES;
            break;
        }
    }
    
    return cell;
}

- (void)resetSepratorWith:(UListViewCell *)cell index:(NSInteger)index
{
    switch (_separatorStyle) {
        case UListViewCellSepratorLineStyleNone:
        {
            cell.headerLineView.hidden = YES;
            cell.footerLineView.hidden = YES;
        }
            break;
            
        case UListViewCellSepratorLineStyleNoEnds:
        {
            if (index == _itemArray.count - 1) {
                cell.headerLineView.hidden = YES;
                cell.footerLineView.hidden = YES;
            } else {
                cell.headerLineView.hidden = YES;
                cell.footerLineView.hidden = NO;
            }
        }
            break;
            
        case UListViewCellSepratorLineStyleFull:
        {
            if (index == 0) {
                cell.headerLineView.hidden = NO;
                cell.footerLineView.hidden = NO;
            } else {
                cell.headerLineView.hidden = YES;
                cell.footerLineView.hidden = NO;
            }
        }
            break;
            
        default:
            break;
    }
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

#pragma mark - Actions

- (void)cellTouchedDownAction:(UListViewCell *)cell
{
    if (!self.multipleSelected) {
        NSArray *cells = [self currentVisibleCellsWith:_scrollView.contentOffset];
        for (UListViewCell *cellItem in cells) {
            if (cellItem != cell) {
                cellItem.contentView.selected = NO;
            }
        }
        
        _selectedIndexs = @[@(cell.index)];
    } else {
        if (!_selectedIndexs) {
            _selectedIndexs = @[@(cell.index)];
        } else {
            BOOL contains = NO;
            for (NSNumber *indexValue in _selectedIndexs) {
                if ([indexValue integerValue] == cell.index) {
                    contains = YES;
                    break;
                }
            }
            
            NSMutableArray *marray = [NSMutableArray arrayWithArray:_selectedIndexs];
            if (!contains) {
                [marray addObject:@(cell.index)];
            } else if (self.cancelable) {
                [marray removeObject:@(cell.index)];
            }
            _selectedIndexs = [marray copy];
        }
    }
    
    if (_delegate) {
        if (cell.selected && [_delegate respondsToSelector:@selector(listView:didSelectCellAtIndex:)]) {
            [_delegate listView:self didSelectCellAtIndex:cell.index];
        } else if (!cell.selected && [_delegate respondsToSelector:@selector(listView:didDeselectCellAtIndex:)]) {
            [_delegate listView:self didDeselectCellAtIndex:cell.index];
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
        [marray addObject:[[class alloc]initWith:_style]];
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
    
    // Reset all
    _currentRange.min = -1;
    _currentRange.max = -1;
    
    _itemArray = nil;
    _selectedIndexs = nil;
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

- (void)selectCellAtIndex:(NSInteger)index
{
    index = (index < 0)?0:index;
    index = (index > _itemArray.count)?_itemArray.count:index;
    
    NSArray *cells = [self currentVisibleCellsWith:_scrollView.contentOffset];
    for (UListViewCell *cell in cells) {
        if (cell.index == index) {
            cell.contentView.selected = YES;
        }
    }
    
    if (!_selectedIndexs) {
        _selectedIndexs = @[@(index)];
    } else {
        BOOL contains = NO;
        for (NSNumber *indexValue in _selectedIndexs) {
            if ([indexValue integerValue] == index) {
                contains = YES;
                break;
            }
        }
        
        if (!contains) {
            NSMutableArray *marray = [NSMutableArray arrayWithArray:_selectedIndexs];
            [marray addObject:@(index)];
            _selectedIndexs = [marray copy];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(listView:didSelectCellAtIndex:)]) {
        [_delegate listView:self didSelectCellAtIndex:index];
    }
}

- (void)deselectCellAtIndex:(NSInteger)index
{
    index = (index < 0)?0:index;
    index = (index > _itemArray.count)?_itemArray.count:index;
    
    NSArray *cells = [self currentVisibleCellsWith:_scrollView.contentOffset];
    for (UListViewCell *cell in cells) {
        if (cell.index == index) {
            cell.contentView.selected = NO;
        }
    }
    
    if (checkValidNSArray(_selectedIndexs)) {
        BOOL contains = NO;
        for (NSNumber *indexValue in _selectedIndexs) {
            if ([indexValue integerValue] == index) {
                contains = YES;
                break;
            }
        }
        
        if (contains) {
            NSMutableArray *marray = [NSMutableArray arrayWithArray:_selectedIndexs];
            [marray removeObject:@(index)];
            _selectedIndexs = [marray copy];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(listView:didDeselectCellAtIndex:)]) {
        [_delegate listView:self didDeselectCellAtIndex:index];
    }
}

@end
