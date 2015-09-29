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

@interface URefreshView ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) URefreshState state;
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
        
        self.height = 50.;
        self.state = URefreshStateIdle;
        
        [self indicatorView];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
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

- (UIndicatorView *)indicatorView
{
    if (_indicatorView) {
        return _indicatorView;
    }
    
    UIndicatorView *indicatorView = [[UIndicatorView alloc]init];
    indicatorView.frame = rectMake(0, 0, 32, 32);
    indicatorView.indicatorWidth = 2.5;
    indicatorView.indicatorColor = sysGrayColor();
    [self addSubview:indicatorView];
    _indicatorView = indicatorView;
    
    return _indicatorView;
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

@end

#pragma mark - URefreshHeaderView

@interface URefreshHeaderView ()
{
    //
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
    self.frame = rectMake(0, - self.height, scrollView.sizeWidth, self.height);
    
    // KVO
    [super.scrollView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Unresponse to refreshing
        if (self.state == URefreshStateRefreshing) {
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
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action];
}

- (void)startRefresh
{
    if (self.state == URefreshStateRefreshing) {
        return;
    }
    self.state = URefreshStateRefreshing;
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = insets.top + self.height;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.indicatorView startAnimation];
                         }
                     }];
    
    // Perform action
    [UThreadPool addTarget:self sel:@selector(performAction)];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateIdle) {
        return;
    }
    self.state = URefreshStateIdle;
    
    // Stop indicator
    [self.indicatorView stopAnimation];
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = insets.top - self.height;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
}

- (void)dealloc
{
    // Remove KVO
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
}

@end

#pragma mark - URefreshFooterView

@interface URefreshFooterView ()
{
    //
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // Unresponse to refreshing
        if (self.state == URefreshStateRefreshing) {
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
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action];
}

- (void)startRefresh
{
    if (self.state == URefreshStateRefreshing) {
        return;
    }
    self.state = URefreshStateRefreshing;
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = insets.bottom + self.height;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.indicatorView startAnimation];
                         }
                     }];
    
    // Perform action
    [UThreadPool addTarget:self sel:@selector(performAction)];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateIdle) {
        return;
    }
    self.state = URefreshStateIdle;
    
    // Stop indicator
    [self.indicatorView stopAnimation];
    
    // Resize
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = insets.bottom - self.height;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
}

- (void)dealloc
{
    // Remove KVO
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

@end
