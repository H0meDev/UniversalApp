//
//  BaseViewController.m
//  UniversalApp
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) NSMutableArray *keyValueObservers;

@end

@implementation BaseViewController

@synthesize globalManager = _globalManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI Configure
    self.containerView.backgroundColor = rgbColor(239, 239, 239);
//    self.statusBarView.backgroundColor = rgbColor(250, 250, 250);
//    self.navigationBarView.backgroundColor = rgbColor(250, 250, 250);
    self.navigationBarView.titleColor = sysBlackColor();
    self.contentView.backgroundColor = rgbColor(239, 239, 239);
    
    // Resize container view
    CGFloat originY = statusHeight() + naviHeight();
    self.containerView.frame = rectMake(0, originY, screenWidth(), screenHeight() - originY);
    
    // Navi back
    self.enableBackButton = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [_globalManager.localNotification removeNotification:self];
    [_globalManager.keyValueObserver removeKeyValueObserver:self];
    
    _globalManager = nil;
}

#pragma mark - Properties

- (GlobalManager *)globalManager
{
    if (_globalManager) {
        return _globalManager;
    }
    
    _globalManager = [GlobalManager manager];
    
    return _globalManager;
}

- (void)setEnableBackButton:(BOOL)enable
{
    _enableBackButton = enable;
    
    if (enable) {
        UNavigationBarButton *leftButton = [UNavigationBarButton button];
        leftButton.frame = rectMake(0, 0, 80, naviHeight() - naviBLineH());
        [leftButton setHAlpha:0.3];
        [leftButton setBackImageWithColor:rgbColor(0, 131, 241)];
        [leftButton setTitleColor:rgbColor(0, 131, 241)];
        [leftButton setTitleFont:systemFont(16)];
        [leftButton addTarget:self action:@selector(backAction)];
        self.navigationBarView.leftButton = leftButton;
        
        // Resize
        leftButton.textAlignment = NSTextAlignmentLeft;
        leftButton.imageFrame = rectMake(0, 0, 0, 0);
        leftButton.titleFrame = rectMake(0, 0, 64, 0);
    } else {
        [self.navigationBarView.leftButton removeFromSuperview];
        self.navigationBarView.leftButton = nil;
    }
}

- (NSMutableArray *)keyValueObservers
{
    if (_keyValueObservers) {
        return _keyValueObservers;
    }
    
    _keyValueObservers = [NSMutableArray array];
    
    return _keyValueObservers;
}

#pragma mark - Action

- (void)backAction
{
    [self popViewController];
}

#pragma mark - Notification

- (void)addNotification:(NSString *)name selector:(SEL)selector
{
    [self.globalManager.localNotification addNotification:self selector:selector name:name];
}

- (void)addNotification:(NSString *)name selector:(SEL)selector object:(id)object
{
    [self.globalManager.localNotification addNotification:self selector:selector name:name object:object];
}

- (void)removeNotification:(NSString *)name
{
    [self.globalManager.localNotification removeNotification:self name:name];
}

- (void)removeNotification:(NSString *)name object:object
{
    [self.globalManager.localNotification removeNotification:self name:name object:object];
}

#pragma mark - KVO

- (void)addKeyValueObject:(id)object keyPath:(NSString *)keyPath
{
    if (!object || !checkValidNSString(keyPath)) {
        return;
    }
    
    [self.globalManager.keyValueObserver addKeyValueObserver:self target:object keyPath:keyPath];
}

- (void)removeKeyValueObject:(id)object keyPath:(NSString *)keyPath
{
    if (!object || !checkValidNSString(keyPath)) {
        return;
    }
    
    [self.globalManager.keyValueObserver removeKeyValueObserver:self target:object keyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // Response to sub call
    [self receivedKVObserverValueForKayPath:keyPath ofObject:object change:change];
}

- (void)receivedKVObserverValueForKayPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
{
    // Needs override
}

@end
