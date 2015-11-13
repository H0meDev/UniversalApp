//
//  UDefines.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#ifndef UFoundation_UDefines_h
#define UFoundation_UDefines_h

#import <UIKit/UIKit.h>

/**
 * Data structs
 */

typedef struct
{
    CGFloat max;
    CGFloat min;
} CGRange;

CG_INLINE CGRange CGRangeMake(CGFloat min, CGFloat max)
{
    CGRange range;
    range.min = min;
    range.max = max;
    
    return range;
}

/**
 * App Universal
 */

// Key window
#define getKeyWindow()  [[UIApplication sharedApplication]keyWindow]

// AppDelegate window
#define getAppWindow()  [[[UIApplication sharedApplication]delegate]window]

// Load resources
#define loadNibName(name) [[[NSBundle mainBundle]loadNibNamed:name owner:self options:nil]lastObject];
#define registerCellNib(tableView, name, identifier) [tableView registerNib:[UINib nibWithNibName:name bundle:nil]forCellReuseIdentifier:identifier]
#define registerCellNibName(name) [tableView registerNib:[UINib nibWithNibName:name bundle:nil]forCellReuseIdentifier:name]

// ARC judgement
#define definedArcMode()  __has_feature(objc_arc)

// Output debug string
#define OutputCurrentDebugInfo() NSLog(@"\n*********************************\nDebug information:\nFile: %s\nLine: %d\nMethod: [%@ %@]\n*********************************",__FILE__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// Output method string
#define OutputCurrentMethodInfo() NSLog(@"\n*********************************\n> [%@ %@]action.\n*********************************", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// System
#define systemVersionString()     [[UIDevice currentDevice]systemVersion]
#define systemVersionFloat()      [[[UIDevice currentDevice]systemVersion]floatValue]
#define currentDeviceModel()      [[UIDevice currentDevice]model]
#define currentDeviceLocalModel() [[UIDevice currentDevice]localizedModel]
#define currentDeviceName()       [[UIDevice currentDevice]name]
#define currentDeviceUUID()       [[UIDevice currentDevice]identifierForVendor] // For iOS6 or higher version

#define AppVersionString()      [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"]
#define AppVersionShortString() [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]
#define AppVersionFloat()       [AppVersionString() floatValue]
#define AppVersionShortFloat()  [AppVersionString() floatValue]

// Base configure
#define statusHeight()           20.0f
#define naviHeight()             44.0f
#define tabHeight()              50.0f
#define naviBLineH()             0.5f
#define tabBLineH()              0.5f

// Animation
#define animationDuration()      0.25f
#define naviAnimtaionDuration()  0.25f

// Font
#define systemFont(size)      [UIFont systemFontOfSize:size]
#define boldSystemFont(size)  [UIFont boldSystemFontOfSize:size]

// Color
#define rgbColor(r,g,b)       [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0f]
#define rgbaColor(r,g,b,a)    [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

// System color
#define sysBlackColor()       [UIColor blackColor]
#define sysDarkGrayColor()    [UIColor darkGrayColor]
#define sysLightGrayColor()   [UIColor lightGrayColor]
#define sysWhiteColor()       [UIColor whiteColor]
#define sysGrayColor()        [UIColor grayColor]
#define sysRedColor()         [UIColor redColor]
#define sysGreenColor()       [UIColor greenColor]
#define sysBlueColor()        [UIColor blueColor]
#define sysCyanColor()        [UIColor cyanColor]
#define sysYellowColor()      [UIColor yellowColor]
#define sysMagentaColor()     [UIColor magentaColor]
#define sysOrangeColor()      [UIColor orangeColor]
#define sysPurpleColor()      [UIColor purpleColor]
#define sysBrownColor()       [UIColor brownColor]
#define sysClearColor()       [UIColor clearColor]

// Rect
#define rectMake(x, y, w, h)                  CGRectMake(x, y, w, h)
#define sizeMake(w, h)                        CGSizeMake(w, h)
#define pointMake(x, y)                       CGPointMake(x, y)
#define edgeMake(top, left, bottom, right)    UIEdgeInsetsMake(top, left, bottom, right)

// Screen
#define screenWidth()       [UIScreen mainScreen].bounds.size.width
#define screenHeight()      [UIScreen mainScreen].bounds.size.height
#define screenBounds()      [UIScreen mainScreen].bounds
#define screenSize()        [UIScreen mainScreen].bounds.size
#define screenWScale()      screenWidth() / 320.
#define screenHScale()      screenWidth() / 320.

// Class check
#define checkClass(object, className)     [object isKindOfClass:[className class]]
#define checkValidNSData(data)            ([data isKindOfClass:NSData.class] && ((NSData *)data).length > 0)
#define checkValidNSString(string)        ([string isKindOfClass:NSString.class] && ((NSString *)string).length > 0)
#define checkValidNSArray(array)          ([array isKindOfClass:NSArray.class] && ((NSArray *)array).count > 0)
#define checkValidNSDictionary(dict)      ([dict isKindOfClass:NSDictionary.class] && ((NSDictionary *)dict).count > 0)
#define checkAction(target, selector)     (target && [target respondsToSelector:selector])

// Data safety
#define checkValidNSDataWith(data, size)       ([data isKindOfClass:NSData.class] && ((NSData *)data).length >= size)
#define checkValidNSStringWith(string, size)   ([string isKindOfClass:NSString.class] && ((NSString *)string).length >= size)
#define checkValidNSArrayWith(array, size)     ([array isKindOfClass:NSArray.class] && ((NSArray *)array).count >= size)
#define checkValidNSDictionaryWith(dict, size) ([dict isKindOfClass:NSDictionary.class] && ((NSDictionary *)dict).count >= size)

// Singleton interface
#define singletonInterface(classname) + (classname *)shared##classname
#define singletonInterfaceWith(classname, method) + (classname *)method

// Singleton implementation
#define singletonImplementation(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname { @synchronized(self) { if (shared##classname == nil) { shared##classname = [[self alloc]init]; } } return shared##classname; } \
+ (id)allocWithZone:(NSZone *)zone { @synchronized(self) {  if (shared##classname == nil) { shared##classname = [super allocWithZone:zone]; return shared##classname; } } return nil; } \
- (id)copyWithZone:(NSZone *)zone { return self; }

#define singletonImplementationWith(classname, method) \
static classname *shared##method = nil; \
+ (classname *)method { @synchronized(self) { if (shared##method == nil) { shared##method = [[self alloc]init]; } } return shared##method; } \
+ (id)allocWithZone:(NSZone *)zone { @synchronized(self) {  if (shared##method == nil) { shared##method = [super allocWithZone:zone]; return shared##method; } } return nil; } \
- (id)copyWithZone:(NSZone *)zone { return self; }

/**
 * App data
 */

// User defaults
#define setUserDefaults(key, object) [[NSUserDefaults standardUserDefaults]setObject:object forKey:key]
#define saveUserDefaults()           [[NSUserDefaults standardUserDefaults]synchronize]
#define getUserDefaults(key)         [[NSUserDefaults standardUserDefaults]objectForKey:key]

// Notification
#define NotificationDefaultCenter    [NSNotificationCenter defaultCenter]

// Path
#define currentDocumentsPath()  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define resourcePathWithName(name, type)  [[NSBundle mainBundle]pathForResource:name ofType:type]
#define bundlePathWithName(name)          [[NSBundle mainBundle]pathForResource:name ofType:@"bundle"]
#define resourcePathWith(bundle, name)    [NSString stringWithFormat:@"%@/%@", bundlePathWithName(bundle), name]
#define cacheDirectoryPath()              [currentDocumentsPath() stringByAppendingPathComponent:@"CachesDirectory"]
#define cachePathWith(name)               [cacheDirectoryPath() stringByAppendingPathComponent:name]

#define checkFileExists(path)         [[NSFileManager defaultManager]fileExistsAtPath:path]
#define checkCacheDirectoryExists()   checkFileExists(cacheDirectoryPath())

#define createCacheDirectory()            [[NSFileManager defaultManager]createDirectoryAtPath:cacheDirectoryPath()\
withIntermediateDirectories:YES attributes:NULL error:NULL]
#define createFile(name)                  [[NSFileManager defaultManager]createFileAtPath:name contents:nil attributes:nil]

// Image
#define loadImage(name)                     [UIImage imageNamed:name]
#define loadImageData(data)                 [UIImage imageWithData:data]
#define loadImageFile(file)                 [UIImage imageWithContentsOfFile:file]
#define loadBundleImage(bundleName, image)  [UIImage imageWithContentsOfFile:resourcePathWith(bundleName, image)]

// GCD queue
#define global_queue()      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define main_queue()        dispatch_get_main_queue()
#define current_queue()     dispatch_get_current_queue()

// HUD
#define showWaitWith(text)    (systemVersionFloat() < 7.0)?[UProgressHUD showWithStatus:text]:[UProgressHUD showLWithStatus:text]
#define showSuccessWith(text) (systemVersionFloat() < 7.0)?[UProgressHUD showSuccessWithStatus:text]:[UProgressHUD showLSuccessWithStatus:text]
#define showErrorWith(text)   (systemVersionFloat() < 7.0)?[UProgressHUD showErrorWithStatus:text]:[UProgressHUD showLErrorWithStatus:text]
#define dismiss()             [UProgressHUD dismiss]

#endif
