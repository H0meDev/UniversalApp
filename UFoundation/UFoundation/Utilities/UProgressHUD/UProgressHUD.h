//
//  UProgressHUD.h
//
//  Created by H0meDev
//  Copyright 2014 All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

typedef NS_ENUM(NSUInteger, UProgressHUDMaskType)
{
    UProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    UProgressHUDMaskTypeClear,    // don't allow
    UProgressHUDMaskTypeBlack,    // don't allow and dim the UI in the back of the HUD
    UProgressHUDMaskTypeGradient  // don't allow and dim the UI with a a-la-alert-view bg gradient
};

@interface UProgressHUD : UIView

// UIStatusBarStyleDefault
+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(UProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(UProgressHUDMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string;

+ (void)dismiss;
+ (void)dismissWithSuccess:(NSString*)successString;
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString;
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

// UIStatusBarStyleLightContent
+ (void)showLight;
+ (void)showLWithStatus:(NSString*)status;
+ (void)showLWithStatus:(NSString*)status maskType:(UProgressHUDMaskType)maskType;
+ (void)showLWithMaskType:(UProgressHUDMaskType)maskType;

+ (void)showLSuccessWithStatus:(NSString*)string;
+ (void)showLSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showLErrorWithStatus:(NSString *)string;
+ (void)showLErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

// Custom UIStatusBarStyle
+ (void)showWithStyle:(UIStatusBarStyle)style;
+ (void)showWithStatus:(NSString*)status style:(UIStatusBarStyle)style;
+ (void)showWithStatus:(NSString*)status maskType:(UProgressHUDMaskType)maskType style:(UIStatusBarStyle)style;
+ (void)showWithMaskType:(UProgressHUDMaskType)maskType style:(UIStatusBarStyle)style;

+ (void)showSuccessWithStatus:(NSString*)string style:(UIStatusBarStyle)style;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration style:(UIStatusBarStyle)style;
+ (void)showErrorWithStatus:(NSString *)string style:(UIStatusBarStyle)style;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration style:(UIStatusBarStyle)style;

@end
