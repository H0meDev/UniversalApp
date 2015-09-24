//
//  URefreshView.m
//  UFoundation
//
//  Created by Think on 15/9/22.
//  Copyright © 2015年 think. All rights reserved.
//

#import "URefreshView.h"

#pragma mark - URefreshView

@interface URefreshView ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation URefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = URefreshStateNone;
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

- (void)addTarget:(id)target action:(SEL)action;
{
    self.target = target;
    self.action = action;
}

- (void)startRefresh
{
    //
}

- (void)finishRefresh
{
    //
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
        CGPoint offset = [change[@"new"] CGPointValue];
        CGFloat topInset = self.scrollView.contentInset.top;
        if ((offset.y + topInset) <= - 50) {
            if (self.scrollView.isDecelerating) {
                // Start refresh
                [self performOnMainThread:@selector(startRefresh)];
            }
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action];
}

- (void)startRefresh
{
    if (self.state == URefreshStateHeaderRefreshing) {
        return;
    }
    self.state = URefreshStateHeaderRefreshing;
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = insets.top + 50;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
    
    // Perform action
    [UThreadPool addTarget:self sel:@selector(performAction)];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateNone) {
        return;
    }
    self.state = URefreshStateNone;
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = insets.top - 50;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
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
        CGPoint offset = [change[@"new"] CGPointValue];
        CGFloat offsetY = self.scrollView.contentSize.height - self.scrollView.sizeHeight + 50;
        if (offset.y >= offsetY) {
            // Start refresh
            if (self.scrollView.isDecelerating) {
                // Start refresh
                [self performOnMainThread:@selector(startRefresh)];
            }
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action];
}

- (void)startRefresh
{
    if (self.state == URefreshStateHeaderRefreshing) {
        return;
    }
    self.state = URefreshStateHeaderRefreshing;
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = insets.bottom + 50;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.scrollView.contentInset = insets;
                     }
                     completion:NULL];
    
    // Perform action
    [UThreadPool addTarget:self sel:@selector(performAction)];
}

- (void)finishRefresh
{
    if (self.state == URefreshStateNone) {
        return;
    }
    self.state = URefreshStateNone;
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = insets.bottom - 50;
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
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
