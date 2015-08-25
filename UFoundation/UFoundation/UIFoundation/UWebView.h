//
//  UWebView.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UWebView;
@protocol UWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(UWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UWebView *)webView;
- (void)webViewDidFinishLoad:(UWebView *)webView;
- (void)webView:(UWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface UWebView : UIView

// Enable progress view, default is YES
@property (nonatomic, assign) BOOL enableProgress;
@property (nonatomic, weak) id <UWebViewDelegate> delegate;
@property (nonatomic, readonly, retain) UIScrollView *scrollView NS_AVAILABLE_IOS(5_0);

// Load from URL string
- (void)loadURLString:(NSString *)url;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data
        MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)textEncodingName
         baseURL:(NSURL *)baseURL;

@property (nonatomic, readonly, retain) NSURLRequest *request;
// Records of access
@property (nonatomic, readonly, retain) NSArray *accessRecords;

- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;

@property (nonatomic, readonly, getter = canGoBack) BOOL canGoBack;
@property (nonatomic, readonly, getter = canGoForward) BOOL canGoForward;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@property (nonatomic) BOOL scalesPageToFit;
@property (nonatomic) BOOL detectsPhoneNumbers NS_DEPRECATED_IOS(2_0, 3_0);
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes NS_AVAILABLE_IOS(3_0);
// iPhone Safari defaults to NO. iPad Safari defaults to YES
@property (nonatomic) BOOL allowsInlineMediaPlayback NS_AVAILABLE_IOS(4_0);
// iPhone and iPad Safari both default to YES
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction NS_AVAILABLE_IOS(4_0);
// iPhone and iPad Safari both default to YES
@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay NS_AVAILABLE_IOS(5_0);
// iPhone and iPad Safari both default to NO
@property (nonatomic) BOOL suppressesIncrementalRendering NS_AVAILABLE_IOS(6_0);
// default is YES
@property (nonatomic) BOOL keyboardDisplayRequiresUserAction NS_AVAILABLE_IOS(6_0);

@property (nonatomic) UIWebPaginationMode paginationMode NS_AVAILABLE_IOS(7_0);
@property (nonatomic) UIWebPaginationBreakingMode paginationBreakingMode NS_AVAILABLE_IOS(7_0);
@property (nonatomic) CGFloat pageLength NS_AVAILABLE_IOS(7_0);
@property (nonatomic) CGFloat gapBetweenPages NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) NSUInteger pageCount NS_AVAILABLE_IOS(7_0);

@end
