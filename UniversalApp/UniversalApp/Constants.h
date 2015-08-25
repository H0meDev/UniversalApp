//
//  Constants.h
//  UniversalApp
//
//  Created by Think on 15/5/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#ifndef UniversalApp_Constants_h
#define UniversalApp_Constants_h

#ifdef APP_DEMO_MODE
/*
 *  For demo
 */

#define SERVER_ADDRESS         @""
#define SERVERICE_ADDRESS      @""
#define VERSION_ADDRESS        @""

// EassMobSDK
#define EASE_APPKID            @""
#define EASE_APPSECRET         @""
#define EASE_APPKEY            @""
#define EASE_APPCERT           @""

// ShareSDK
#define SHARE_QQ_APPID         @""
#define SHARE_QQ_APPKEY        @""
#define SHARE_WX_APPID         @""
#define SHARE_WX_APPKEY        @""

// Umeng
#define UMENG_APPKEY           @""

#else
/*
 *  For production
 */

#define SERVER_ADDRESS         @""
#define SERVERICE_ADDRESS      @""
#define VERSION_ADDRESS        @""

// EassMobSDK
#define EASE_APPKID            @""
#define EASE_APPSECRET         @""
#define EASE_APPKEY            @""
#define EASE_APPCERT           @""

// Umeng
#define UMENG_APPKEY           @""


#endif

// Defines

// For skin
#define loadSkinImage(name)   [[GlobalManager manager].skinManager imageForKey:name]
#define loadSkinColor(name)   [[GlobalManager manager].skinManager colorForKey:name]
#define loadSkinValue(name)   [[GlobalManager manager].skinManager resourceValueForKey:name]

#endif
