//
//  UWebView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UWebView.h"
#import "UDefines.h"
#import "UTimerBooster.h"
#import "UIView+UAExtension.h"
#import "NSObject+UAExtension.h"
#import "NSArray+UAExtension.h"
#import "NSDate+UAExtension.h"

@interface UWebViewProgressView : UIView
{
    CGRect _innerFrame;
    CGFloat _maxAutoloadProgress;
    UIImageView *_progressView;
    UIImageView *_backgroundView;
}

@property (nonatomic, copy) UIColor *colorOfProgress;
@property (nonatomic, copy) UIColor *colorOfBackground;
@property (nonatomic, assign) NSInteger progress; // From 0 to 100
@property (nonatomic, readonly) BOOL isFinish;

- (void)stepIt; // Random progress value

@end

@implementation UWebViewProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initalize
        self.backgroundColor = sysClearColor();
        _maxAutoloadProgress = 98;
        
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.backgroundColor = sysClearColor();
        [self addSubview:_backgroundView];
        
        _progressView = [[UIImageView alloc]init];
        _progressView.backgroundColor = sysClearColor();
        [self addSubview:_progressView];
        
        self.colorOfProgress = rgbColor(0, 117, 225);
        self.colorOfBackground = rgbColor(196, 196, 196);
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(CGRectZero, frame)) {
        _innerFrame = frame;
        
        // Resize
        _backgroundView.size = frame.size;
    }
}

- (void)setProgress:(NSInteger)progress
{
    progress = (progress < 0)?0:progress;
    progress = (progress > 100)?100:progress;
    
    if (progress < _progress) {
        _progressView.frame = rectMake(0, 0, 0, _innerFrame.size.height);
    }
    
    _progress = progress;
    CGFloat unitValue = _innerFrame.size.width / 100.0f;
    CGFloat width = unitValue * _progress;
    
    if (progress > 0) {
        _progressView.backgroundColor = self.colorOfProgress;
    }
    _backgroundView.backgroundColor = self.colorOfBackground;
    
    UWebViewProgressView *weakself = self.weakself;
    [UIView animateWithDuration:animationDuration() animations:^{
        _progressView.frame = rectMake(0, 0, width, weakself.sizeHeight);
    } completion:^(BOOL finished) {
        if (finished && weakself.isFinish) {
            _progressView.backgroundColor = sysClearColor();
            _backgroundView.backgroundColor = sysClearColor();
            _progressView.frame = rectMake(0, 0, 0, _innerFrame.size.height);
        }
    }];
}

- (void)stepIt
{
    NSInteger stepValue = self.progress;
    if (stepValue < 80) {
        stepValue += 10 + random() % 20;
        stepValue = (stepValue > 80)?80:stepValue;
    } else {
        stepValue += 2;
    }
    
    stepValue = (stepValue > _maxAutoloadProgress)?_maxAutoloadProgress:stepValue;
    self.progress = stepValue;
}

- (BOOL)isFinish
{
    return (_progress % 100 == 0);
}

@end

@interface UWebView () <UIWebViewDelegate>
{
    BOOL _enableProgress;
}

@property (nonatomic, retain) UWebViewProgressView *progressView;
@property (nonatomic, retain) UIWebView *webView;

@end

@implementation UWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initliaze
        self.backgroundColor = sysWhiteColor();
        self.userInteractionEnabled = YES;
        _enableProgress = YES;
        
        // Start timer
        [UTimerBooster start];
    }
    
    return self;
}

- (void)dealloc
{
    // Remove timer target
    [UTimerBooster removeTarget:self];
    
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    self.webView = nil;
}

#pragma mark - Properties

- (UWebViewProgressView *)progressView
{
    if (_progressView) {
        return _progressView;
    }
    
    UWebViewProgressView *progressView = [[UWebViewProgressView alloc]init];
    progressView.backgroundColor = sysLightGrayColor();
    [self addSubview:progressView];
    _progressView = progressView;
    
    return _progressView;
}

- (UIWebView *)webView
{
    if (_webView) {
        return _webView;
    }
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    [self addSubview:webView];
    _webView = webView;
    
    return _webView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(CGRectZero, frame)) {
        if (_enableProgress) {
            self.webView.frame = rectMake(0, 2.4, frame.size.width, frame.size.height - 2.4);
            self.progressView.frame = rectMake(0, 0, frame.size.width, 2.4);
        } else {
            self.webView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
        }
    }
}

- (void)setEnableProgress:(BOOL)enable
{
    _enableProgress = enable;
    
    // Refresh
    [self setFrame:self.frame];
}

#pragma mark - Methods

- (void)autoLoadingProgress
{
    [self.progressView performOnMainThread:@selector(stepIt)];
}

- (void)startAutoProgress
{
    if (!_enableProgress) {
        return;
    }
    
    if (self.progressView.isFinish) {
        self.progressView.progress = 20;
        
        [UTimerBooster removeTarget:self sel:@selector(autoLoadingProgress) all:YES];
        [UTimerBooster addTarget:self sel:@selector(autoLoadingProgress) time:0.5 repeat:-1];
    }
}

- (void)finishAutoProgress
{
    if (!_enableProgress) {
        return;
    }
    
    if (!self.progressView.isFinish) {
        self.progressView.progress = 100;
        
        [UTimerBooster removeTarget:self sel:@selector(autoLoadingProgress) all:YES];
    }
}

- (void)loadURLString:(NSString *)url
{
    @autoreleasepool
    {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10];
        [self loadRequest:request];
    }
}

- (void)addAccessRecord:(NSURL *)url
{
    @autoreleasepool
    {
        if (url) {
            NSString *urlString = url.absoluteString;
            if (urlString && urlString.length > 6 && ![urlString isEqualToString:@"about:blank"]) {
                NSNumber *time = [NSNumber numberWithInteger:[NSDate timeInterval]];
                if (!_accessRecords) {
                    _accessRecords = @[@{@"time":time, @"url":urlString}];
                } else {
                    NSDictionary *lastRecord = [_accessRecords lastObject];
                    NSDictionary *record = @{@"time":time, @"url":urlString};
                    
                    if ([urlString isEqualToString:lastRecord[@"url"]]) {
                        NSInteger index = _accessRecords.count - 1;
                        _accessRecords = [_accessRecords replaceObjectWithIndex:index withObject:record];
                    } else {
                        _accessRecords = [_accessRecords addWithObject:record];
                    }
                }
            }
        }
    }
}

#pragma mark - UIWebView Like Methods

- (UIScrollView *)scrollView
{
    return self.webView.scrollView;
}

- (void)loadRequest:(NSURLRequest *)request
{
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    
    [self.webView loadHTMLString:string baseURL:baseURL];
}

- (void)loadData:(NSData *)data
        MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)textEncodingName
         baseURL:(NSURL *)baseURL
{
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    
    [self.webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
}

- (NSURLRequest *)request
{
    return self.webView.request;
}

- (void)reload
{
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    
    [self.webView reload];
}

- (void)stopLoading
{
    [self.webView stopLoading];
}

- (void)goBack
{
    [self.webView goBack];
}

- (void)goForward
{
    [self.webView goForward];
}

- (BOOL)canGoBack
{
    return self.webView.canGoBack;
}

- (BOOL)canGoForward
{
    return self.canGoForward;
}

- (BOOL)isLoading
{
    return self.webView.isLoading;
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script
{
    return [self.webView stringByEvaluatingJavaScriptFromString:script];
}

- (BOOL)scalesPageToFit
{
    return self.webView.scalesPageToFit;
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    self.webView.scalesPageToFit = scalesPageToFit;
}

- (BOOL)detectsPhoneNumbers
{
    return self.webView.detectsPhoneNumbers;
}

- (void)setDetectsPhoneNumbers:(BOOL)detectsPhoneNumbers
{
    self.webView.detectsPhoneNumbers = detectsPhoneNumbers;
}

- (UIDataDetectorTypes)dataDetectorTypes
{
    return self.webView.dataDetectorTypes;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    self.webView.dataDetectorTypes = dataDetectorTypes;
}

- (BOOL)allowsInlineMediaPlayback
{
    return self.webView.allowsInlineMediaPlayback;
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    self.webView.allowsInlineMediaPlayback = allowsInlineMediaPlayback;
}

- (BOOL)mediaPlaybackRequiresUserAction
{
    return self.webView.mediaPlaybackRequiresUserAction;
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction
{
    self.webView.mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
}

- (BOOL)mediaPlaybackAllowsAirPlay
{
    return self.webView.mediaPlaybackAllowsAirPlay;
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    self.webView.mediaPlaybackAllowsAirPlay = mediaPlaybackAllowsAirPlay;
}

- (BOOL)suppressesIncrementalRendering
{
    return self.webView.suppressesIncrementalRendering;
}

- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    self.webView.suppressesIncrementalRendering = suppressesIncrementalRendering;
}

- (BOOL)keyboardDisplayRequiresUserAction
{
    return self.webView.keyboardDisplayRequiresUserAction;
}

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction
{
    self.webView.keyboardDisplayRequiresUserAction = keyboardDisplayRequiresUserAction;
}

- (UIWebPaginationMode)paginationMode
{
    return self.webView.paginationMode;
}

- (void)setPaginationMode:(UIWebPaginationMode)paginationMode
{
    self.webView.paginationMode = paginationMode;
}

- (UIWebPaginationBreakingMode)paginationBreakingMode
{
    return self.webView.paginationBreakingMode;
}

- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode
{
    self.webView.paginationBreakingMode = paginationBreakingMode;
}

- (CGFloat)pageLength
{
    return self.webView.pageLength;
}

- (void)setPageLength:(CGFloat)pageLength
{
    self.webView.pageLength = pageLength;
}

- (CGFloat)gapBetweenPages
{
    return self.webView.gapBetweenPages;
}

- (void)setGapBetweenPages:(CGFloat)gapBetweenPages
{
    self.webView.gapBetweenPages = gapBetweenPages;
}

- (NSUInteger)pageCount
{
    return self.webView.pageCount;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldLoad = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        shouldLoad = [_delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    if (shouldLoad && _enableProgress) {
        [self performAsyncOnMainQueue:@"startAutoProgress"];
    }
    
    return shouldLoad;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_delegate webViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self addAccessRecord:webView.request.URL];
    [self performAsyncOnMainQueue:@"finishAutoProgress"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self performAsyncOnMainQueue:@"finishAutoProgress"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_delegate webView:self didFailLoadWithError:error];
    }
}

@end
