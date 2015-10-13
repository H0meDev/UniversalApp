//
//  UBarButton.m
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UBarButton.h"
#import "UDefines.h"
#import "ULabel.h"
#import "UImageView.h"
#import "UIView+UAExtension.h"

@interface UBarButtonItem : NSObject

// UI element
@property (nonatomic, assign) UIControlState state;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat backgroundAlpha;

+ (id)item;

@end

@implementation UBarButtonItem

+ (id)item
{
    __autoreleasing UBarButtonItem *item = [[UBarButtonItem alloc]init];
    
    return item;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initalize
        self.alpha = 1.0;
        self.backgroundAlpha = 1.0;
    }
    
    return self;
}

@end

@interface UBarButton ()
{
    NSMutableArray *_stateItems;
    BOOL _isSelected;
}

@property (nonatomic, strong) ULabel *titleLabel;
@property (nonatomic, strong) UImageView *imageView;
@property (nonatomic, strong) UImageView *backgroundView;

@end

@implementation UBarButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initalize
        _stateItems = [NSMutableArray array];
        _textAlignment = NSTextAlignmentCenter;
        
        // Default
        [self setTitleColor:sysBlackColor()];
        [self setTitleFont:systemFont(16)];
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
}

- (UIColor *)backgroundColor
{
    return self.backgroundView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundView.backgroundColor = backgroundColor;
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
    titleLabel.numberOfLines = 0;
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
    backgroundView.backgroundColor = sysClearColor();
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    return _backgroundView;
}

#pragma mark - Event callback

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self refreshButtonWith:UIControlStateHighlighted];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self refreshButtonWith:UIControlStateHighlighted];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_isSelected) {
        [self refreshButtonWith:UIControlStateSelected];
    } else {
        [self refreshButtonWith:UIControlStateNormal];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    if (_isSelected) {
        [self refreshButtonWith:UIControlStateSelected];
    } else {
        [self refreshButtonWith:UIControlStateNormal];
    }
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

#pragma mark -  Inner Methods

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.title = title;
    } else {
        buttonItem = [UBarButtonItem item];
        buttonItem.state = state;
        buttonItem.title = title;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.titleLabel.text = title;
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.color = color;
    } else {
        buttonItem = [UBarButtonItem item];
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
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.font = font;
    } else {
        buttonItem = [UBarButtonItem item];
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
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.image = image;
    } else {
        buttonItem = [UBarButtonItem item];
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
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.backgroundImage = image;
    } else {
        buttonItem = [UBarButtonItem item];
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
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.alpha = alpha;
    } else {
        buttonItem = [UBarButtonItem item];
        buttonItem.state = state;
        buttonItem.alpha = alpha;
        [_stateItems addObject:buttonItem];
    }
    
    if (UIControlStateNormal == state) {
        self.titleLabel.alpha = alpha;
        self.imageView.alpha = alpha;
    }
}

- (void)setBackgroundAlpha:(CGFloat)alpha forState:(UIControlState)state
{
    UBarButtonItem *buttonItem = [self itemWith:state];
    if (buttonItem) {
        buttonItem.backgroundAlpha = alpha;
    } else {
        buttonItem = [UBarButtonItem item];
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
    UBarButtonItem *item = [self itemWith:state];
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
        }
        
        // Alpha
        self.titleLabel.alpha = item.alpha;
        self.imageView.alpha = item.alpha;
        self.backgroundView.alpha = item.backgroundAlpha;
    }
}

- (UBarButtonItem *)itemWith:(UIControlState)state
{
    for (UBarButtonItem *item in _stateItems) {
        if (item.state == state) {
            return item;
        }
    }
    
    return nil;
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

#pragma mark - Target

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTouchDownTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (void)removeTarget:(id)target action:(SEL)action
{
    [self removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeTouchDownTarget:(id)target action:(SEL)action
{
    [self removeTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

@end
