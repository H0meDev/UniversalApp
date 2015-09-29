//
//  URefreshView.m
//  UFoundation
//
//  Created by Think on 15/9/22.
//  Copyright © 2015年 think. All rights reserved.
//

#import "URefreshView.h"
#import "UIndicatorView.h"

#pragma mark - URefreshView

@interface URefreshView () <URefreshViewDelegate>

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) URefreshState state;
@property (nonatomic, retain) ULabel *stateLabel;
@property (nonatomic, retain) UIndicatorView *indicatorView;

@end

@implementation URefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        self.backgroundColor = sysClearColor();
        self.clipsToBounds = YES;
        self.delegate = self;
        
        self.height = 50.;
        self.state = URefreshStateIdle;
        
        [self indicatorView];
        
        [super addObserver:self
                forKeyPath:@"state"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context:NULL];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero) && self.state != URefreshStateRefreshing) {
        self.stateLabel.center = pointMake(frame.size.width / 2., frame.size.height / 2.);
        self.indicatorView.center = pointMake(frame.size.width / 2., frame.size.height / 2.);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (ULabel *)stateLabel
{
    if (_stateLabel) {
        return _stateLabel;
    }
    
    ULabel *stateLabel = [[ULabel alloc]init];
    stateLabel.frame = rectMake(0, 0, 168, 32);
    stateLabel.font = systemFont(15);
    stateLabel.textColor = sysLightGrayColor();
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:stateLabel];
    _stateLabel = stateLabel;
    
    return _stateLabel;
}

- (UIndicatorView *)indicatorView
{
    if (_indicatorView) {
        return _indicatorView;
    }
    
    UIndicatorView *indicatorView = [[UIndicatorView alloc]init];
    indicatorView.hidden = YES;
    indicatorView.frame = rectMake(0, 0, 24, 24);
    indicatorView.indicatorWidth = 1.5;
    indicatorView.indicatorColor = sysDarkGrayColor();
    [self addSubview:indicatorView];
    _indicatorView = indicatorView;
    
    return _indicatorView;
}

- (void)setEnable:(BOOL)enable
{
    // Finish current
    [self finishRefresh];
    
    // Change state
    self.state = enable?URefreshStateIdle:URefreshStateDisable;
}

- (void)addTarget:(id)target action:(SEL)action;
{
    self.target = target;
    self.action = action;
}

- (void)startRefresh
{
    // To be override
}

- (void)finishRefresh
{
    // To be override
}

- (void)performAction
{
    if (self.target && self.action && [self.target respondsToSelector:self.action]) {
        [self.target performWithName:NSStringFromSelector(self.action) with:self.scrollView];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"state" context:NULL];
}

@end

#pragma mark - URefreshHeaderView

@interface URefreshHeaderView ()
{
    CGFloat _insetValue;
}

@end

@implementation URefreshHeaderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (super.scrollView) {
        // Remove KVO
        [super.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    }
    super.scrollView = scrollView;
    
    // Add to scrollView & resize
    [scrollView addSubview:self];
    
    _insetValue = scrollView.contentInset.top;
    self.frame = rectMake(0, - self.height, scrollView.sizeWidth, self.height);
    
    // KVO
    [super.scrollView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
}

- (void)setEnable:(BOOL)enable
{
    [super setEnable:enable];
    
    self.stateLabel.text = enable?URefreshViewHeaderIdleTitle:URefreshViewHeaderDisableTitle;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Unresponse to refreshing or disable
        if (self.state == URefreshStateRefreshing ||
            self.state == URefreshStateDisable)
        {
            return;
        }
        
        CGPoint offset = [change[@"new"] CGPointValue];
        CGFloat topInset = self.scrollView.contentInset.top;
        CGFloat offsetY = offset.y + topInset;
        offsetY = (offsetY > 0)?0:offsetY;
        
        if (offsetY <= - self.height) {
            self.state = URefreshStateReady;
        } else {
            self.state = URefreshStateIdle;
        }
        
        CGFloat progress = 0;
        if (self.scrollView.dragging) {
            progress = - (offsetY / (self.sizeHeight + 10.));
            progress = (progress < 0.)?0.:progress;
            progress = (progress > 1.)?1.:progress;
        }
        
        if (self.state == URefreshStateReady && !self.scrollView.dragging) {
            // Start refresh
            [self performOnMainThread:@selector(startRefresh)];
        } else if (checkAction(self.delegate, @selector(refreshView:progress:))) {
            // Callback
            [self.delegate refreshView:self progress:progress];
        }
    } else if ([keyPath isEqualToString:@"state"]) {
        URefreshState state = [change[@"new"] integerValue];
        switch (state) {
            case URefreshStateIdle:
            {
                self.stateLabel.text = URefreshViewHeaderIdleTitle;
                self.stateLabel.sizeWidth = self.stateLabel.contentWidth;
                self.stateLabel.center = pointMake(self.sizeWidth / 2., self.sizeHeight / 2.);
            }
                break;
                
            case URefreshStateReady:
            {
                self.stateLabel.text = URefreshViewHeaderReadyTitle;
                self.stateLabel.sizeWidth = self.stateLabel.contentWidth;
                self.stateLabel.center = pointMake(self.sizeWidth / 2., self.sizeHeight / 2.);
            }
                break;
                
            case URefreshStateRefreshing:
            {
                self.stateLabel.text = URefreshViewHeaderRefreshingTitle;
                self.stateLabel.sizeWidth = self.stateLabel.contentWidth;
                
                CGFloat width = self.stateLabel.sizeWidth + self.indicatorView.sizeWidth;
                CGFloat originX = (self.sizeWidth - width) / 2. - 8.;
                self.indicatorView.originX = originX;
                self.stateLabel.originX = self.indicatorView.paddingRight + 8.0;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action];
}

- (void)startRefresh
{
    if (self.state == URefreshStateRefreshing ||
        self.state == URefreshStateDisable)
    {
        return;
    }
    self.state = URefreshStateRefreshing;
    
    // Animation
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimation];
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = _insetValue + self.height;
    CGPoint offset = self.scrollView.contentOffset;
    offset.y = - self.height;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentOffset = offset;
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
    
    // Perform action
    [UThreadPool addTarget:self sel:@selector(performAction)];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateIdle ||
        self.state == URefreshStateDisable)
    {
        return;
    }
    self.state = URefreshStateIdle;
    
    // Stop indicator
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimation];
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = _insetValue;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
}

- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress
{
    //
}

- (void)dealloc
{
    // Remove KVO
    if (super.scrollView) {
        [super.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    }
}

@end

#pragma mark - URefreshFooterView

@interface URefreshFooterView ()
{
    CGFloat _insetValue;
}

@end

@implementation URefreshFooterView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (super.scrollView) {
        // Remove KVO
        [super.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    }
    super.scrollView = scrollView;
    
    // Add to scrollView
    [scrollView addSubview:self];
    
    _insetValue = scrollView.contentInset.bottom;
    
    // KVO
    [super.scrollView addObserver:self
                       forKeyPath:@"contentOffset"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:NULL];
    [super.scrollView addObserver:self
                       forKeyPath:@"contentSize"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:NULL];
}

- (void)setEnable:(BOOL)enable
{
    [super setEnable:enable];
    
    self.stateLabel.text = enable?URefreshViewFooterIdleTitle:URefreshViewFooterDisableTitle;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Unresponse to refreshing or disable
        if (self.state == URefreshStateRefreshing ||
            self.state == URefreshStateDisable)
        {
            return;
        }
        
        CGPoint offset = [change[@"new"] CGPointValue];
        CGFloat offsetY = offset.y - (self.scrollView.contentSize.height - self.scrollView.sizeHeight);
        offsetY = (offsetY < 0)?0:offsetY;
        
        if (offsetY >= self.height) {
            self.state = URefreshStateReady;
        } else {
            self.state = URefreshStateIdle;
        }
        
        CGFloat progress = 0;
        if (self.scrollView.dragging) {
            progress = offsetY / (self.sizeHeight + 10.);
            progress = (progress < 0.)?0.:progress;
            progress = (progress > 1.)?1.:progress;
        }
        
        if (self.state == URefreshStateReady && !self.scrollView.dragging) {
            // Start refresh
            [self performOnMainThread:@selector(startRefresh)];
        } else if (checkAction(self.delegate, @selector(refreshView:progress:))) {
            // Callback
            [self.delegate refreshView:self progress:progress];
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [change[@"new"] CGSizeValue];
        self.frame = rectMake(0, size.height, self.scrollView.sizeWidth, self.height);
    } else if ([keyPath isEqualToString:@"state"]) {
        URefreshState state = [change[@"new"] integerValue];
        switch (state) {
            case URefreshStateIdle:
            {
                self.stateLabel.text = URefreshViewFooterIdleTitle;
                self.stateLabel.sizeWidth = self.stateLabel.contentWidth;
                self.stateLabel.center = pointMake(self.sizeWidth / 2., self.sizeHeight / 2.);
            }
                break;
                
            case URefreshStateReady:
            {
                self.stateLabel.text = URefreshViewFooterReadyTitle;
                self.stateLabel.sizeWidth = self.stateLabel.contentWidth;
                self.stateLabel.center = pointMake(self.sizeWidth / 2., self.sizeHeight / 2.);
            }
                break;
                
            case URefreshStateRefreshing:
            {
                self.stateLabel.text = URefreshViewFooterRefreshingTitle;
                self.stateLabel.sizeWidth = self.stateLabel.contentWidth;
                
                CGFloat width = self.stateLabel.sizeWidth + self.indicatorView.sizeWidth;
                CGFloat originX = (self.sizeWidth - width) / 2. - 8.;
                self.indicatorView.originX = originX;
                self.stateLabel.originX = self.indicatorView.paddingRight + 8.0;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action];
}

- (void)startRefresh
{
    if (self.state == URefreshStateRefreshing ||
        self.state == URefreshStateDisable)
    {
        return;
    }
    self.state = URefreshStateRefreshing;
    
    // Animation
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimation];
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = _insetValue + self.height;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
    
    // Perform action
    [UThreadPool addTarget:self sel:@selector(performAction)];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateIdle ||
        self.state == URefreshStateDisable)
    {
        return;
    }
    self.state = URefreshStateIdle;
    
    // Stop indicator
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimation];
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = _insetValue;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
}

- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress
{
    //
}

- (void)dealloc
{
    // Remove KVO
    if (super.scrollView) {
        [super.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
        [super.scrollView removeObserver:self forKeyPath:@"contentSize" context:NULL];
    }
}

@end
