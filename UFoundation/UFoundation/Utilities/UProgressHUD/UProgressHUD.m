//
//  UProgressHUD.m
//
//  Created by H0meDev
//  Copyright 2014 All rights reserved.
//
//

#import "UProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "UDefines.h"

@interface UProgressHUDViewController : UIViewController

@property (nonatomic, assign) UIStatusBarStyle statusStyle;

@end

@implementation UProgressHUDViewController

- (void)setStatusStyle:(UIStatusBarStyle)style
{
    _statusStyle = style;
    
    if (systemVersionFloat() >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [[UIApplication sharedApplication]setStatusBarStyle:style];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusStyle;
}

@end

@interface UProgressHUD ()

@property (nonatomic, readwrite) UProgressHUDMaskType maskType;
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *hudView;
@property (nonatomic, strong, readonly) UILabel *stringLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)showWithStatus:(NSString*)string maskType:(UProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show style:(UIStatusBarStyle)style;
- (void)setStatus:(NSString*)string;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

- (void)dismiss;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds;

@end


@implementation UProgressHUD

@synthesize overlayWindow, hudView, maskType, fadeOutTimer, stringLabel, imageView, spinnerView, visibleKeyboardHeight;

- (void)dealloc
{
    self.fadeOutTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (UProgressHUD*)sharedView
{
    static dispatch_once_t once;
    static UProgressHUD *sharedView;
    dispatch_once(&once, ^ { sharedView = [[UProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}


+ (void)setStatus:(NSString *)string
{
    [[UProgressHUD sharedView] setStatus:string];
}

#pragma mark - Show Methods

+ (void)show
{
    [[UProgressHUD sharedView] showWithStatus:nil maskType:UProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithStyle:(UIStatusBarStyle)style
{
    [[UProgressHUD sharedView] showWithStatus:nil maskType:UProgressHUDMaskTypeNone networkIndicator:NO style:style];
}

+ (void)showWithStatus:(NSString *)status
{
    [[UProgressHUD sharedView] showWithStatus:status maskType:UProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithStatus:(NSString *)status style:(UIStatusBarStyle)style
{
    [[UProgressHUD sharedView] showWithStatus:status maskType:UProgressHUDMaskTypeNone networkIndicator:NO style:style];
}

+ (void)showWithMaskType:(UProgressHUDMaskType)maskType
{
    [[UProgressHUD sharedView] showWithStatus:nil maskType:maskType networkIndicator:NO];
}

+ (void)showWithMaskType:(UProgressHUDMaskType)maskType style:(UIStatusBarStyle)style
{
    [[UProgressHUD sharedView] showWithStatus:nil maskType:maskType networkIndicator:NO style:style];
}

+ (void)showWithStatus:(NSString*)status maskType:(UProgressHUDMaskType)maskType
{
    [[UProgressHUD sharedView] showWithStatus:status maskType:maskType networkIndicator:NO];
}

+ (void)showWithStatus:(NSString*)status maskType:(UProgressHUDMaskType)maskType style:(UIStatusBarStyle)style
{
    [[UProgressHUD sharedView] showWithStatus:status maskType:maskType networkIndicator:NO style:style];
}

+ (void)showSuccessWithStatus:(NSString *)string
{
    [UProgressHUD showSuccessWithStatus:string duration:1];
}

+ (void)showSuccessWithStatus:(NSString *)string style:(UIStatusBarStyle)style
{
    [UProgressHUD showSuccessWithStatus:string duration:1 style:style];
}

+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration
{
    [UProgressHUD show];
    [UProgressHUD dismissWithSuccess:string afterDelay:duration];
}

+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration style:(UIStatusBarStyle)style
{
    [UProgressHUD showWithStyle:style];
    [UProgressHUD dismissWithSuccess:string afterDelay:duration];
}

+ (void)showErrorWithStatus:(NSString *)string
{
    [UProgressHUD showErrorWithStatus:string duration:1];
}

+ (void)showErrorWithStatus:(NSString *)string style:(UIStatusBarStyle)style
{
    [UProgressHUD showErrorWithStatus:string duration:1 style:style];
}

+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration
{
    [UProgressHUD show];
    [UProgressHUD dismissWithError:string afterDelay:duration];
}

+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration style:(UIStatusBarStyle)style
{
    [UProgressHUD showWithStyle:style];
    [UProgressHUD dismissWithError:string afterDelay:duration];
}

+(void)showLight
{
    [self showWithStyle:UIStatusBarStyleLightContent];
}

+ (void)showLWithStatus:(NSString*)status
{
    [self showWithStatus:status style:UIStatusBarStyleLightContent];
}

+ (void)showLWithStatus:(NSString*)status maskType:(UProgressHUDMaskType)maskType
{
    [self showWithStatus:status maskType:maskType style:UIStatusBarStyleLightContent];
}

+ (void)showLWithMaskType:(UProgressHUDMaskType)maskType
{
    [self showWithMaskType:maskType style:UIStatusBarStyleLightContent];
}

+ (void)showLSuccessWithStatus:(NSString*)string
{
    [self showSuccessWithStatus:string style:UIStatusBarStyleLightContent];
}

+ (void)showLSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration
{
    [self showSuccessWithStatus:string style:UIStatusBarStyleLightContent];
}

+ (void)showLErrorWithStatus:(NSString *)string
{
    [self showErrorWithStatus:string style:UIStatusBarStyleLightContent];
}

+ (void)showLErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration
{
    [self showErrorWithStatus:string duration:duration style:UIStatusBarStyleLightContent];
}

#pragma mark - Dismiss Methods

+ (void)dismiss
{
    [[UProgressHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString*)successString
{
    [[UProgressHUD sharedView] dismissWithStatus:successString error:NO];
}

+ (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds
{
    [[UProgressHUD sharedView] dismissWithStatus:successString error:NO afterDelay:seconds];
}

+ (void)dismissWithError:(NSString*)errorString
{
    [[UProgressHUD sharedView] dismissWithStatus:errorString error:YES];
}

+ (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds
{
    [[UProgressHUD sharedView] dismissWithStatus:errorString error:YES afterDelay:seconds];
}


#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
        case UProgressHUDMaskTypeBlack:
        {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
        }
            break;
            
        case UProgressHUDMaskTypeGradient:
        {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
        }
            break;
            
        default:
            break;
    }
}

- (void)setStatus:(NSString *)string
{
    CGFloat hudWidth = 100;
    CGFloat hudHeight = 100;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    if(string) {
        CGSize stringSize = CGSizeZero;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            NSDictionary *attributes = @{NSFontAttributeName:self.stringLabel.font};
            stringSize = [string boundingRectWithSize:sizeMake(200, 300)
                                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attributes context:nil].size;
        } else {
            stringSize = [string sizeWithFont:self.stringLabel.font
                            constrainedToSize:sizeMake(200, 300)
                                lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        hudHeight = 80 + stringHeight;
        
        if(stringWidth > hudWidth) {
            hudWidth = ceil(stringWidth/2)*2;
        }
        
        if(hudHeight > 100) {
            labelRect = CGRectMake(12, 66, hudWidth, stringHeight);
            hudWidth+=24;
        } else {
            hudWidth+=24;
            labelRect = CGRectMake(0, 66, hudWidth, stringHeight);
        }
    }
    
    self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    if(string) {
        self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, 36);
    } else {
       	self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, CGRectGetHeight(self.hudView.bounds)/2);
    }
    
    self.stringLabel.hidden = NO;
    self.stringLabel.text = string;
    self.stringLabel.frame = labelRect;
    
    if(string) {
        self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, 40.5);
    } else {
        self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, ceil(self.hudView.bounds.size.height/2)+0.5);
    }
}

- (void)setFadeOutTimer:(NSTimer *)newTimer
{
    if(fadeOutTimer) {
        [fadeOutTimer invalidate];
        fadeOutTimer = nil;
    }
    
    if(newTimer) {
        fadeOutTimer = newTimer;
    }
}


- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)positionHUD:(NSNotification*)notification
{
    CGFloat keyboardHeight;
    double animationDuration = 0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation)) {
                keyboardHeight = keyboardFrame.size.height;
            } else {
                keyboardHeight = keyboardFrame.size.width;
            }
        } else {
            keyboardHeight = 0;
        }
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    activeHeight -= keyboardHeight;
    
    CGFloat posY = activeHeight/2 + 10;
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
        }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        {
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
        }
            break;
            
        case UIInterfaceOrientationLandscapeRight:
        {
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
        }
            break;
            
        default: // as UIInterfaceOrientationPortrait
        {
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
        }
            break;
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    } else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle
{
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    self.hudView.center = newCenter;
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string maskType:(UProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show style:(UIStatusBarStyle)style
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview) {
            [self.overlayWindow addSubview:self];
        }
        
        self.fadeOutTimer = nil;
        self.imageView.hidden = YES;
        self.maskType = hudMaskType;
        
        [self setStatus:string];
        [self.spinnerView startAnimating];
        
        if(self.maskType != UProgressHUDMaskTypeNone) {
            self.overlayWindow.userInteractionEnabled = YES;
        } else {
            self.overlayWindow.userInteractionEnabled = NO;
        }
        
        UProgressHUDViewController *viewController = (UProgressHUDViewController *)self.overlayWindow.rootViewController;
        viewController.statusStyle = style;
        [self.overlayWindow makeKeyAndVisible];
        [self positionHUD:nil];
        
        if(self.alpha != 1) {
            [self registerNotifications];
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
            [UIView animateWithDuration:0.15
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                                 self.alpha = 1;
                             }
                             completion:NULL];
        }
        
        [self setNeedsDisplay];
    });
}

- (void)showWithStatus:(NSString*)string maskType:(UProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show
{
    [self showWithStatus:string maskType:hudMaskType networkIndicator:show style:UIStatusBarStyleDefault];
}

- (void)dismissWithStatus:(NSString*)string error:(BOOL)error
{
    [self dismissWithStatus:string error:error afterDelay:0.9];
}

- (void)dismissWithStatus:(NSString *)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.alpha != 1)
            return;
        
        if (error) {
            self.imageView.image = loadBundleImage(@"Resource", @"hud_error_white");
        } else {
            self.imageView.image = loadBundleImage(@"Resource", @"hud_success_white");
        }
        
        self.imageView.hidden = NO;
        [self setStatus:string];
        [self.spinnerView stopAnimating];
        
        self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    });
}

- (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [[NSNotificationCenter defaultCenter] removeObserver:self];
                                 [hudView removeFromSuperview];
                                 hudView = nil;
                                 
                                 // Make sure to remove the overlay window from the list of windows
                                 // before trying to find the key window in that same list
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow.rootViewController = nil;
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

#pragma mark - Utilities

+ (BOOL)isVisible
{
    return ([UProgressHUD sharedView].alpha == 1);
}

#pragma mark - Getters

- (UIWindow *)overlayWindow
{
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:rectMake(0, 0, screenWidth(), screenHeight())];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
        overlayWindow.rootViewController = [[UProgressHUDViewController alloc]init];
    }
    return overlayWindow;
}

- (UIView *)hudView
{
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectZero];
        hudView.layer.cornerRadius = 10;
        hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel
{
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        stringLabel.textColor = [UIColor whiteColor];
        stringLabel.backgroundColor = [UIColor clearColor];
        stringLabel.adjustsFontSizeToFitWidth = YES;
        stringLabel.textAlignment = NSTextAlignmentCenter;
        stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        stringLabel.font = [UIFont boldSystemFontOfSize:16];
        stringLabel.shadowColor = [UIColor blackColor];
        stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview) {
        [self.hudView addSubview:stringLabel];
    }
    
    return stringLabel;
}

- (UIImageView *)imageView
{
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    }
    
    if(!imageView.superview) {
        [self.hudView addSubview:imageView];
    }
    
    return imageView;
}

- (UIActivityIndicatorView *)spinnerView
{
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinnerView.hidesWhenStopped = YES;
        spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    }
    
    if(!spinnerView.superview) {
        [self.hudView addSubview:spinnerView];
    }
    
    return spinnerView;
}

- (CGFloat)visibleKeyboardHeight
{
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIKeyboard.
    UIView *foundKeyboard = nil;
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
    
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}

@end