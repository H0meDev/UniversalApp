//
//  UButton.m
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UButton.h"
#import "NSObject+UAExtension.h"

@interface UButtonItem : NSObject

// UI element
@property (nonatomic, assign) UIControlState state;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat contentAlpha;
@property (nonatomic, assign) CGFloat backgroundAlpha;

+ (id)item;

@end

@implementation UButtonItem

+ (id)item
{
    __autoreleasing UButtonItem *item = [[UButtonItem alloc]init];
    
    return item;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize
        self.contentAlpha = 1.0;
        self.backgroundAlpha = 1.0;
    }
    
    return self;
}

@end

@interface UBarButtonActionItem : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) UIControlEvents event;

+ (id)item;

@end

@implementation UBarButtonActionItem

+ (id)item
{
    __autoreleasing UBarButtonActionItem *item = [[UBarButtonActionItem alloc]init];
    
    return item;
}

@end

@interface UButton ()
{
    UIView *_backgroundMaskView;
    
    NSMutableArray *_stateItems;
    NSMutableArray *_actionItems;
    BOOL _isSelected;
}

@property (nonatomic, strong) ULabel *titleLabel;
@property (nonatomic, strong) UImageView *imageView;
@property (nonatomic, strong) UImageView *backgroundView;

@end

@implementation UButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        _stateItems = [NSMutableArray array];
        _actionItems = [NSMutableArray array];
        
        _textAlignment = NSTextAlignmentCenter;
        _showMaskWhenHighlighted = YES;
        _backgroundMaskHColor = rgbaColor(0, 0, 0, 0.3);
        
        // Default
        [self setTitleColor:sysBlackColor()];
        [self setTitleFont:systemFont(16)];
        
        // Actions
        [super addTarget:self action:@selector(touchDownAction) forControlEvents:UIControlEventTouchDown];
        [super addTarget:self action:@selector(touchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
        [super addTarget:self action:@selector(touchDragOutsideAction) forControlEvents:UIControlEventTouchDragOutside];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectEqualToRect(self.titleLabel.frame, CGRectZero)) {
        self.titleLabel.frame = rectMake(0, 0, frame.size.width, frame.size.height);
    }
    
    if (CGRectEqualToRect(self.titleLabel.frame, CGRectZero)) {
        self.imageView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
    }
    
    self.backgroundView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
    _backgroundMaskView.frame = self.backgroundView.bounds;
}

- (void)addSubview:(UIView *)view
{
    [self.backgroundView addSubview:view];
    [self.backgroundView insertSubview:view belowSubview:_backgroundMaskView];
}

- (void)dealloc
{
    [_actionItems removeAllObjects];
    _actionItems = nil;
    
    [_stateItems removeAllObjects];
    _stateItems = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (ULabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    ULabel *titleLabel = [[ULabel alloc]init];
    titleLabel.backgroundColor = sysClearColor();
    titleLabel.textColor = sysBlackColor();
    titleLabel.userInteractionEnabled = NO;
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    
    UImageView *imageView = [[UImageView alloc]init];
    imageView.backgroundColor = sysClearColor();
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundView addSubview:imageView];
    _imageView = imageView;
    
    return _imageView;
}

- (UImageView *)backgroundView
{
    if (_backgroundView) {
        return _backgroundView;
    }
    
    UImageView *backgroundView = [[UImageView alloc]init];
    backgroundView.userInteractionEnabled = NO;
    backgroundView.backgroundColor = sysClearColor();
    [super addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    UIView *backgroundMaskView = [[UIView alloc]init];
    backgroundMaskView.backgroundColor = sysClearColor();
    backgroundMaskView.userInteractionEnabled = NO;
    _backgroundMaskView = backgroundMaskView;
    [backgroundView addSubview:_backgroundMaskView];
    
    return _backgroundView;
}

- (UIColor *)backgroundColor
{
    return self.backgroundView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundView.backgroundColor = backgroundColor;
}

#pragma mark - Event callback

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    dispatch_async(main_queue(), ^{
        [self refreshButtonWith:UIControlStateHighlighted];
        
        if (_delegate && [_delegate respondsToSelector:@selector(buttonBeginTracking:)]) {
            [_delegate buttonBeginTracking:self.weakself];
        }
    });
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    dispatch_async(main_queue(), ^{
        [self refreshButtonWith:UIControlStateHighlighted];
        
        if (_delegate && [_delegate respondsToSelector:@selector(buttonContinueTracking:)]) {
            [_delegate buttonContinueTracking:self.weakself];
        }
    });
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    dispatch_async(main_queue(), ^{
        if (_isSelected) {
            [self refreshButtonWith:UIControlStateSelected];
        } else {
            [self refreshButtonWith:UIControlStateNormal];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(buttonEndTracking:)]) {
            [_delegate buttonEndTracking:self.weakself];
        }
    });
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    dispatch_async(main_queue(), ^{
        if (_isSelected) {
            [self refreshButtonWith:UIControlStateSelected];
        } else {
            [self refreshButtonWith:UIControlStateNormal];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(buttonCancelTracking:)]) {
            [_delegate buttonCancelTracking:self.weakself];
        }
    });
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _isSelected = selected;
    
    // Selected
    if (!selected) {
        [self refreshButtonWith:UIControlStateNormal];
    } else {
        [self refreshButtonWith:UIControlStateSelected];
    }
}

#pragma mark -  Actions

- (void)touchDownAction
{
    [self performActionWithEvent:UIControlEventTouchDown];
}

- (void)touchUpInsideAction
{
    [self performActionWithEvent:UIControlEventTouchUpInside];
}

- (void)touchDragOutsideAction
{
    [self refreshButtonWith:UIControlStateNormal];
}

#pragma mark - Targets

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    //
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    //
}

- (void)setTarget:(id)target action:(SEL)action
{
    [self addActionWithEvent:UIControlEventTouchUpInside target:target action:action];
}

- (void)setTouchDownTarget:(id)target action:(SEL)action
{
    [self addActionWithEvent:UIControlEventTouchDown target:target action:action];
}

- (void)removeTargetAction
{
    [self removeActionWithEvent:UIControlEventTouchUpInside];
}

- (void)removeTouchDownTargetAction
{
    [self removeActionWithEvent:UIControlEventTouchDown];
}

#pragma mark -  Inner Methods

- (void)autoresizeWithTitle
{
    if (_titleLabel) {
        CGFloat sizeWidth = _titleLabel.contentWidth;
        CGFloat maxWidth = screenWidth() * 0.25;
        
        sizeWidth = (sizeWidth > maxWidth)?maxWidth:sizeWidth;
        _titleLabel.sizeWidth = sizeWidth;
        self.sizeWidth = _titleLabel.right;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.title = title;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.title = title;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.titleLabel.text = title;
        
        if (_needsAutoResize) {
            [self autoresizeWithTitle];
        }
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.color = color;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.color = color;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.titleLabel.textColor = color;
    }
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.font = font;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.font = font;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.titleLabel.font = font;
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.image = image;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.image = image;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.imageView.image = image;
    }
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.backgroundImage = image;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.backgroundImage = image;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.backgroundView.image = image;
    }
}

- (void)setAlpha:(CGFloat)alpha forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.contentAlpha = alpha;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.contentAlpha = alpha;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.titleLabel.alpha = alpha;
        self.imageView.alpha = alpha;
    }
}

- (void)setBackgroundAlpha:(CGFloat)alpha forState:(UIControlState)state
{
    UButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.backgroundAlpha = alpha;
    } else {
        buttonItem = [UButtonItem item];
        buttonItem.state = state;
        buttonItem.backgroundAlpha = alpha;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.backgroundView.alpha = alpha;
    }
}

- (void)refreshButtonWith:(UIControlState)state
{
    UButtonItem *item = [self itemWith:state];
    if (item) {
        if (item.title) {
            self.titleLabel.text = item.title;
        }
        
        if (item.color) {
            self.titleLabel.textColor = item.color;
        }
        
        if (item.font) {
            self.titleLabel.font = item.font;
        }
        
        if (item.image) {
            self.imageView.image = item.image;
        }
        
        if (item.backgroundImage) {
            self.backgroundView.image = item.backgroundImage;
        } else if (UIControlStateHighlighted == state && _showMaskWhenHighlighted) {
            _backgroundMaskView.backgroundColor = _backgroundMaskHColor;
        } else {
            _backgroundMaskView.backgroundColor = sysClearColor();
        }
        
        // Alpha
        self.titleLabel.alpha = item.contentAlpha;
        self.imageView.alpha = item.contentAlpha;
        self.backgroundView.alpha = item.backgroundAlpha;
    } else if (UIControlStateHighlighted == state && _showMaskWhenHighlighted) {
        _backgroundMaskView.backgroundColor = _backgroundMaskHColor;
    } else {
        _backgroundMaskView.backgroundColor = sysClearColor();
    }
}

- (UButtonItem *)itemWith:(UIControlState)state
{
    for (UButtonItem *item in _stateItems) {
        if (item.state == state) {
            return item;
        }
    }
    
    return nil;
}

- (void)performActionWithEvent:(UIControlEvents)event
{
    UBarButtonActionItem *actionItem = nil;
    for (UBarButtonActionItem *item in _actionItems) {
        if (item.event == event) {
            actionItem = item;
            break;
        }
    }
    
    if (actionItem) {
        if (_synchronous) {
            [actionItem.target performWithName:NSStringFromSelector(actionItem.action) with:self];
        } else {
            dispatch_async(main_queue(), ^{
                [actionItem.target performWithName:NSStringFromSelector(actionItem.action) with:self];
            });
        }
    }
}

- (void)addActionWithEvent:(UIControlEvents)event target:(id)target action:(SEL)action
{
    UBarButtonActionItem *actionItem = nil;
    for (UBarButtonActionItem *item in _actionItems) {
        if (item.event == UIControlEventTouchUpInside) {
            actionItem = item;
            break;
        }
    }
    
    if (actionItem) {
        [_actionItems removeObject:actionItem];
    } else {
        actionItem = [UBarButtonActionItem item];
    }
    
    actionItem.target = target;
    actionItem.action = action;
    actionItem.event = UIControlEventTouchUpInside;
    [_actionItems addObject:actionItem];
}

- (void)removeActionWithEvent:(UIControlEvents)event
{
    UBarButtonActionItem *actionItem = nil;
    for (UBarButtonActionItem *item in _actionItems) {
        if (item.event == event) {
            actionItem = item;
            break;
        }
    }
    
    [_actionItems removeObject:actionItem];
}

#pragma mark -  Outer Methods

+ (id)button
{
    return [[self.class alloc]init];
}

- (void)setImageFrame:(CGRect)frame
{
    _imageFrame = frame;
    
    self.imageView.frame = frame;
}

- (void)setTitleFrame:(CGRect)frame
{
    _titleFrame = frame;
    
    self.titleLabel.frame = frame;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.titleLabel.textAlignment = textAlignment;
}

#pragma mark - UserInterface

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setHTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setSTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)setDTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setHTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setSTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setDTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateDisabled];
}

- (void)setTitleFont:(UIFont *)font
{
    [self setTitleFont:font forState:UIControlStateNormal];
}

- (void)setHTitleFont:(UIFont *)font
{
    [self setTitleFont:font forState:UIControlStateHighlighted];
}

- (void)setSTitleFont:(UIFont *)font
{
    [self setTitleFont:font forState:UIControlStateSelected];
}

- (void)setDTitleFont:(UIFont *)font
{
    [self setTitleFont:font forState:UIControlStateDisabled];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setHImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setSImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateSelected];
}

- (void)setDImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateDisabled];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setHBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)setSBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setDBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateDisabled];
}

- (void)setAlpha:(CGFloat)alpha
{
    [self setAlpha:alpha forState:UIControlStateNormal];
}

- (void)setHAlpha:(CGFloat)alpha
{
    [self setAlpha:alpha forState:UIControlStateHighlighted];
}

- (void)setSAlpha:(CGFloat)alpha
{
    [self setAlpha:alpha forState:UIControlStateSelected];
}

- (void)setDAlpha:(CGFloat)alpha
{
    [self setAlpha:alpha forState:UIControlStateDisabled];
}

- (void)setBackgroundAlpha:(CGFloat)alpha
{
    [self setBackgroundAlpha:alpha forState:UIControlStateNormal];
}

- (void)setHBackgroundAlpha:(CGFloat)alpha
{
    [self setBackgroundAlpha:alpha forState:UIControlStateHighlighted];
}

- (void)setSBackgroundAlpha:(CGFloat)alpha
{
    [self setBackgroundAlpha:alpha forState:UIControlStateSelected];
}

- (void)setDBackgroundAlpha:(CGFloat)alpha
{
    [self setBackgroundAlpha:alpha forState:UIControlStateDisabled];
}

@end
