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
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) URefreshState state;
@property (nonatomic, strong) ULabel *stateLabel;
@property (nonatomic, strong) UIndicatorView *indicatorView;

@end

@implementation URefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        self.backgroundColor = sysClearColor();
        self.clipsToBounds = YES;
        
        self.height = 60.;
        self.progress = 0;
        self.delegate = self;
        self.state = URefreshStateNone;
        self.scrollEnableWhenRefreshing = YES;
        
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
    
    if (!CGRectEqualToRect(frame, CGRectZero) && self.state != URefreshStateLoading) {
        self.stateLabel.centerY = frame.size.height / 2.;
        self.indicatorView.centerY = frame.size.height / 2.;
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
    
    CGFloat originX = 70 * screenWScale();
    ULabel *stateLabel = [[ULabel alloc]init];
    stateLabel.frame = rectMake(originX, 0, screenWidth() - originX * 2, 40);
    stateLabel.font = systemFont(16);
    stateLabel.textColor = sysDarkGrayColor();
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
    indicatorView.frame = rectMake(40 * screenWScale(), 0, 30., 30.);
    indicatorView.style = UIndicatorStyleProgressCircle;
    indicatorView.indicatorColor = sysDarkGrayColor();
    indicatorView.indicatorGapAngle = M_PI * 0.2;
    [self addSubview:indicatorView];
    _indicatorView = indicatorView;
    
    return _indicatorView;
}

- (void)setEnable:(BOOL)enable
{
    // Finish current
    [self finishRefresh];
    
    // Change state
    self.indicatorView.progress = 0;
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        self.titleOfIdle = URefreshViewHeaderIdleTitle;
        self.titleOfReady = URefreshViewHeaderReadyTitle;
        self.titleOfLoading = URefreshViewHeaderLoadingTitle;
        self.titleOfDisable = URefreshViewHeaderDisableTitle;
    }
    
    return self;
}

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
        if (self.state == URefreshStateLoading || self.state == URefreshStateDisable) {
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewWillStartRefresh:)]) {
                [self.delegate refreshViewWillStartRefresh:self];
            }
            
            // Start refresh
            [self performOnMainThread:@selector(startRefresh)];
        } else if (checkAction(self.delegate, @selector(refreshView:progress:))) {
            // Callback
            if (self.progress != progress) {
                [self.delegate refreshView:self progress:progress];
                self.progress = progress;
            }
        }
    } else if ([keyPath isEqualToString:@"state"]) {
        URefreshState state = [change[@"new"] integerValue];
        switch (state) {
            case URefreshStateIdle:
            {
                self.stateLabel.text = self.titleOfIdle;
            }
                break;
                
            case URefreshStateReady:
            {
                self.stateLabel.text = self.titleOfReady;
            }
                break;
                
            case URefreshStateLoading:
            {
                self.stateLabel.text = self.titleOfLoading;
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
    if (self.state == URefreshStateLoading || self.state == URefreshStateDisable) {
        return;
    }
    self.state = URefreshStateLoading;
    
    // Disable scroll
    self.scrollView.scrollEnabled = self.scrollEnableWhenRefreshing;
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = _insetValue + self.height;
    
    [UIView animateWithDuration:animationDuration() - 0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Start animation
                             [self.indicatorView startAnimation];
                             
                             // Perform action
                             [UThreadPool addTarget:self sel:@selector(performAction)];
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewDidStartRefresh:)]) {
                                 [self.delegate refreshViewDidStartRefresh:self];
                             }
                         }
                     }];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateIdle || self.state == URefreshStateDisable) {
        return;
    }
    self.state = URefreshStateIdle;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewWillFinishRefresh:)]) {
        [self.delegate refreshViewWillFinishRefresh:self];
    }
    
    [self.indicatorView stopAnimation];
    
    // Enable scroll
    self.scrollView.scrollEnabled = YES;
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = _insetValue;
    
    [UIView animateWithDuration:animationDuration() - 0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.indicatorView.progress = 0;
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewDidFinishRefresh:)]) {
                                 [self.delegate refreshViewDidFinishRefresh:self];
                             }
                         }
                     }];
}

- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress
{
    CGFloat delta = self.indicatorView.progress - progress;
    if (fabs(delta) <= 0.1) {
        self.indicatorView.progress = progress;
    } else {
        [self.indicatorView setProgress:progress animated:YES];
    }
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        self.titleOfIdle = URefreshViewFooterIdleTitle;
        self.titleOfReady = URefreshViewFooterReadyTitle;
        self.titleOfLoading = URefreshViewFooterLoadingTitle;
        self.titleOfDisable = URefreshViewFooterDisableTitle;
    }
    
    return self;
}

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
        if (self.state == URefreshStateLoading || self.state == URefreshStateDisable) {
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewWillStartRefresh:)]) {
                [self.delegate refreshViewWillStartRefresh:self];
            }
            
            // Start refresh
            [self performOnMainThread:@selector(startRefresh)];
        } else if (checkAction(self.delegate, @selector(refreshView:progress:))) {
            // Callback
            if (self.progress != progress) {
                [self.delegate refreshView:self progress:progress];
                self.progress = progress;
            }
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [change[@"new"] CGSizeValue];
        self.frame = rectMake(0, size.height, self.scrollView.sizeWidth, self.height);
    } else if ([keyPath isEqualToString:@"state"]) {
        URefreshState state = [change[@"new"] integerValue];
        switch (state) {
            case URefreshStateIdle:
            {
                self.stateLabel.text = self.titleOfIdle;
            }
                break;
                
            case URefreshStateReady:
            {
                self.stateLabel.text = self.titleOfReady;
            }
                break;
                
            case URefreshStateLoading:
            {
                self.stateLabel.text = self.titleOfLoading;
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
    if (self.state == URefreshStateLoading || self.state == URefreshStateDisable) {
        return;
    }
    self.state = URefreshStateLoading;
    
    // Disable scroll
    self.scrollView.scrollEnabled = self.scrollEnableWhenRefreshing;
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = _insetValue + self.height;
    
    [UIView animateWithDuration:animationDuration() - 0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Start animation
                             [self.indicatorView startAnimation];
                             
                             // Perform action
                             [UThreadPool addTarget:self sel:@selector(performAction)];
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewDidStartRefresh:)]) {
                                 [self.delegate refreshViewDidStartRefresh:self];
                             }
                         }
                     }];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateIdle || self.state == URefreshStateDisable) {
        return;
    }
    self.state = URefreshStateIdle;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewWillFinishRefresh:)]) {
        [self.delegate refreshViewWillFinishRefresh:self];
    }
    
    [self.indicatorView stopAnimation];
    
    // Enable scroll
    self.scrollView.scrollEnabled = YES;
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = _insetValue;
    
    [UIView animateWithDuration:animationDuration() - 0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.indicatorView.progress = 0;
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewDidFinishRefresh:)]) {
                                 [self.delegate refreshViewDidFinishRefresh:self];
                             }
                         }
                     }];
}

- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress
{
    CGFloat delta = self.indicatorView.progress - progress;
    if (fabs(delta) <= 0.1) {
        self.indicatorView.progress = progress;
    } else {
        [self.indicatorView setProgress:progress animated:YES];
    }
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
