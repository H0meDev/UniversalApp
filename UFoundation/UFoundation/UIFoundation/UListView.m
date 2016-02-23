//
//  UListView.m
//  UFoundation
//
//  Created by Think on 15/11/26.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"
#import "NSObject+UAExtension.h"
#import "NSArray+UAExtension.h"
#import "UIColor+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UIScrollView+UAExtension.h"

#pragma mark - UListViewCellItem class

@interface UListViewCellItem : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat originValue; // Value of origin
@property (nonatomic, assign) CGFloat sizeValue;   // Value of size
@property (nonatomic, assign) BOOL selected;       // Selection

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
        _highlightedColor = [sysBlackColor() colorWithAlpha:0.15];
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
    [super addSubview:backgroundMaskView];
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
        [self removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    _target = target;
    _action = action;
    
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Event callback

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.backgroundMaskView.backgroundColor = _highlightedColor;
    
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

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [super insertSubview:view belowSubview:_backgroundMaskView];
}

@end

#pragma mark - UListViewCell class

@interface UListViewCell ()
{
    __weak id _target;
    SEL _action;
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
    @autoreleasepool
    {
        return [[[self class] alloc]initWithFrame:CGRectZero];
    }
}

- (id)initWith:(UListViewStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initalize
        super.backgroundColor = sysClearColor();
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
    [contentView setTarget:self action:@selector(touchUpInsideAction)];
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
        
        switch (_style) {
            case UListViewStyleHorizontal:
            {
                self.headerLineView.frame = rectMake(0, 0, headerValue, height);
                self.footerLineView.frame = rectMake(width - footerValue, 0, footerValue, height);
            }
                break;
                
            case UListViewStyleVertical:
            {
                self.headerLineView.frame = rectMake(0, 0, width, headerValue);
                self.footerLineView.frame = rectMake(0, height - footerValue, width, footerValue);
            }
                break;
                
            default:
                break;
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
    
    self.contentView.highlightedColor = _highlightedColor;
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

- (void)cellNeedsUpdate
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

- (void)touchUpInsideAction
{
    if (self.cancelable && self.contentView.selected) {
        self.contentView.selected = NO;
    } else {
        self.contentView.selected = YES;
    }
    
    if (self.contentView.selected) {
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
    NSArray *_itemArray; // Array of UListViewCellItem
    NSMutableDictionary *_cellReusePool;
    NSInteger _selectedIndex; // For NO multiable selection
}

// For cells
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation UListView

@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = UListViewStyleVertical;
        _separatorStyle = UListViewCellSepratorLineStyleNoEnds;
        
        _spaceValue = 0;
        _headerValue = 0;
        _footerValue = 0;
        _selectedIndex = -1;
        
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
    if (_cellReusePool) {
        [_cellReusePool removeAllObjects];
    }
    
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
    scrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
    scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
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
    
    switch (_style) {
        case UListViewStyleHorizontal:
        {
            self.scrollView.showsVerticalScrollIndicator = NO;
            self.scrollView.showsHorizontalScrollIndicator = YES;
            self.scrollView.contentSize = sizeMake(frame.size.width, 0);
        }
            break;
            
        case UListViewStyleVertical:
        {
            self.scrollView.showsVerticalScrollIndicator = YES;
            self.scrollView.showsHorizontalScrollIndicator = NO;
            self.scrollView.contentSize = sizeMake(0, frame.size.height);
        }
            break;
            
        default:
            break;
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
    if (!self.multipleSelected) {
        if (_selectedIndex > 0) {
            return @[@(_selectedIndex)];
        }
    } else {
        NSMutableArray *marray = [NSMutableArray array];
        for (UListViewCellItem *item in _itemArray) {
            if (item.selected) {
                [marray addObject:@(item.index)];
            }
        }
        
        return [marray copy];
    }
    
    return nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Dequeue all views
        [self dequeueAllItemsWith:[change[@"new"] CGPointValue]];
    }
}

#pragma mark - Methods

- (void)dequeueAllItemsWith:(CGPoint)offset
{
    if (_itemArray) {
        CGRange range = [self visibleRangeWith:offset];
        NSInteger beginIndex = range.min;
        NSInteger endIndex = range.max;
        
        if (_itemArray.count > endIndex) {
            for (NSInteger index = beginIndex; index <= endIndex; index ++) {
                NSArray *cells = [self currentVisibleCellsWith:offset];
                
                BOOL needsAttached = NO;
                if ((index - beginIndex) <= cells.count) {
                    needsAttached = ![self checkCellWith:index from:cells];
                } else {
                    needsAttached = YES;
                }
                
                if (needsAttached) {
                    // Attach cell
                    [self attachCellWith:index];
                }
            }
        }
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
        
        BOOL needsBreak = NO;
        for (NSInteger index = 0; index < _itemArray.count; index ++) {
            UListViewCellItem *item = _itemArray[index];
            CGFloat minValue = item.originValue;
            CGFloat maxValue = item.originValue + item.sizeValue;
            
            switch (_style) {
                case UListViewStyleHorizontal:
                {
                    if (beginIndex == -1 && maxValue > offsetLValue) {
                        beginIndex = index;
                    }
                    
                    if ((maxValue < offsetRValue) || (minValue < offsetRValue && maxValue > offsetRValue)) {
                        endIndex = index;
                    } else {
                        needsBreak = YES;
                    }
                }
                    break;
                    
                case UListViewStyleVertical:
                {
                    if (beginIndex == -1 && maxValue > offsetTValue) {
                        beginIndex = index;
                    }
                    
                    if ((maxValue < offsetBValue) || (minValue < offsetBValue && maxValue > offsetBValue)) {
                        endIndex = index;
                    } else {
                        needsBreak = YES;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            if (needsBreak) {
                break;
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
        if (checkClass(cell, UListViewCell)) {
            if (![self checkVisibleWith:cell offset:offset]) {
                if (cell.superview) {
                    // Remove
                    [cell removeFromSuperview];
                }
            } else {
                [subviews addObject:cell];
            }
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
        for (UListViewCell *cellItem in cells) {
            switch (_style) {
                case UListViewStyleHorizontal:
                {
                    if (cellItem.originX == item.originValue) {
                        contains = YES;
                    }
                }
                    break;
                    
                case UListViewStyleVertical:
                {
                    if (cellItem.originY == item.originValue) {
                        contains = YES;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            if (contains) {
                break;
            }
        }
    }
    
    return contains;
}

- (void)attachCellWith:(NSInteger)index
{
    UListViewCellItem *item = _itemArray[index];
    UListViewCell *cell = [self cellAtIndex:index];
    
    // Attached to scrollView
    [self.contentView addSubview:cell];
    
    // Resize
    switch (_style) {
        case UListViewStyleHorizontal:
        {
            cell.frame = rectMake(item.originValue, 0, item.sizeValue, self.scrollView.sizeHeight);
        }
            break;
            
        case UListViewStyleVertical:
        {
            cell.frame = rectMake(0, item.originValue, self.scrollView.sizeWidth, item.sizeValue);
        }
            break;
            
        default:
            break;
    }
    
    // Reset cell seprator line
    [self resetSepratorWith:cell index:index];
}

- (UListViewCell *)cellAtIndex:(NSInteger)index
{
    UListViewCellItem *item = _itemArray[index];
    if (!self.multipleSelected) {
        if (_selectedIndex != -1 && index == _selectedIndex) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }
    
    UListViewCell *cell = [self.dataSource listView:self.weakself cellAtIndex:index];
    cell.index = index;
    cell.cancelable = self.cancelable;
    cell.contentView.selected = item.selected;
    [cell setTarget:self action:@selector(cellTouchedUpAction:)];
    
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
    
    [cell.contentView bringSubviewToFront:cell.headerLineView];
    [cell.contentView bringSubviewToFront:cell.footerLineView];
}

#pragma mark - Actions

- (void)cellTouchedUpAction:(UListViewCell *)cell
{
    NSArray *cells = [self currentVisibleCellsWith:_scrollView.contentOffset];
    
    for (UListViewCell *cellItem in cells) {
        UListViewCellItem *item = _itemArray[cellItem.index];
        if (cellItem.index == cell.index) {
            item.selected = (self.cancelable && item.selected)?NO:YES;
            cellItem.contentView.selected = item.selected;
            
            if (!self.multipleSelected) {
                _selectedIndex = (item.selected)?cellItem.index:-1;
            }
        } else if (!self.multipleSelected) {
            item.selected = NO;
            cellItem.contentView.selected = item.selected;
        }
    }
    
    if (_delegate) {
        if (cell.selected && [_delegate respondsToSelector:@selector(listView:didSelectCellAtIndex:)]) {
            dispatch_async(main_queue(), ^{
                [_delegate listView:self.weakself didSelectCellAtIndex:cell.index];
            });
        } else if (!cell.selected && [_delegate respondsToSelector:@selector(listView:didDeselectCellAtIndex:)]) {
            dispatch_async(main_queue(), ^{
                [_delegate listView:self.weakself didDeselectCellAtIndex:cell.index];
            });
        }
    }
}

#pragma mark - Outer Methods

- (UListViewCell *)cellReuseWith:(NSString *)cellName forIdentifier:(NSString *)identifier
{
    @autoreleasepool
    {
        UListViewCell *cell = nil;
        if (!checkValidNSString(cellName) || !checkValidNSString(identifier)) {
            return cell;
        }
        
        Class class = NSClassFromString(cellName);
        if (class && [class isSubclassOfClass:[UListViewCell class]]) {
            cell = [[class alloc]initWith:_style];
            NSArray *array = _cellReusePool[identifier];
            NSMutableArray *marray = (!array)?[NSMutableArray array]:[array mutableCopy];
            [marray addObject:cell];
            [_cellReusePool setObject:[marray copy] forKey:identifier];
        }
        
        return cell;
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
    
    if (cell) {
        // Reset for reuse
        [cell cellNeedsUpdate];
    }
    
    return cell;
}

- (void)reloadData
{
    [self reloadDataWith:CGPointZero];
}

- (void)reloadDataWith:(CGPoint)offset
{
    if (_itemArray == nil) {
        return;
    }
    
    // Remove all cells
    [self.contentView removeAllSubviews];
    
    _itemArray = nil;
    [_cellReusePool removeAllObjects];
    
    CGFloat originValue = _headerValue; // Header
    NSInteger count = [self.dataSource numberOfItemsInListView:self.weakself];
    NSMutableArray *marray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < count; index ++) {
        @autoreleasepool
        {
            CGFloat sizeValue = [_delegate listView:self.weakself sizeValueForIndex:index];
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
    }
    
    _itemArray = [marray copy];
    originValue += _footerValue; // Footer
    
    // Resize
    switch (_style) {
        case UListViewStyleHorizontal:
        {
            self.contentView.sizeWidth = originValue;
            self.scrollView.contentSize = sizeMake(originValue, 0);
        }
            break;
            
        case UListViewStyleVertical:
        {
            self.contentView.sizeHeight = originValue;
            self.scrollView.contentSize = sizeMake(0, originValue);
        }
            break;
            
        default:
            break;
    }
    
    // Load cells
    self.scrollView.contentOffset = offset;
}

- (void)clearSelectedIndexs
{
    for (UListViewCellItem *item in _itemArray) {
        item.selected = NO;
    }
    
    [self reloadData];
}

- (void)moveToIndex:(NSInteger)index
{
    [self moveToIndex:index animated:YES];
}

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!_itemArray) {
        [self reloadData];
    }
    
    index = (index < 0)?0:index;
    index = (index >= _itemArray.count)?_itemArray.count - 1:index;
    
    UListViewCellItem *item = _itemArray[index];
    CGFloat originValue = item.originValue;
    CGPoint offset = CGPointZero;
    
    switch (_style) {
        case UListViewStyleHorizontal:
        {
            offset = pointMake(originValue, 0);
        }
            break;
            
        case UListViewStyleVertical:
        {
            offset = pointMake(0, originValue);
        }
            break;
            
        default:
            break;
    }
    
    [self.scrollView setContentOffset:offset animated:animated];
}

- (void)selectCellAtIndex:(NSInteger)index
{
    index = (index < 0)?0:index;
    index = (index > _itemArray.count)?_itemArray.count:index;
    
    NSArray *cells = [self currentVisibleCellsWith:_scrollView.contentOffset];
    for (UListViewCell *cellItem in cells) {
        UListViewCellItem *item = _itemArray[cellItem.index];
        if (cellItem.index == index) {
            item.selected = YES;
            cellItem.contentView.selected = item.selected;
        } else if (!self.multipleSelected) {
            item.selected = NO;
            cellItem.contentView.selected = item.selected;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(listView:didSelectCellAtIndex:)]) {
        dispatch_async(main_queue(), ^{
            [_delegate listView:self.weakself didSelectCellAtIndex:index];
        });
    }
}

- (void)deselectCellAtIndex:(NSInteger)index
{
    [self deselectCellAtIndex:index animated:YES];
}

- (void)deselectCellAtIndex:(NSInteger)index animated:(BOOL)animated
{
    index = (index < 0)?0:index;
    index = (index > _itemArray.count)?_itemArray.count:index;
    
    UListViewCellItem *item = _itemArray[index];
    item.selected = NO;
    
    __weak UListViewCell *cell = nil;
    NSArray *cells = [self currentVisibleCellsWith:_scrollView.contentOffset];
    for (UListViewCell *cellItem in cells) {
        if (cellItem.index == index) {
            cell = cellItem;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(listView:didDeselectCellAtIndex:)]) {
        dispatch_async(main_queue(), ^{
            [_delegate listView:self.weakself didDeselectCellAtIndex:index];
        });
    }
    
    if (cell) {
        if (!animated) {
            cell.contentView.selected = NO;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                cell.contentView.selected = NO;
            }];
        }
    }
}

@end
