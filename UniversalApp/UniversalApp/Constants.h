//
//  Constants.h
//  UniversalApp
//
//  Created by Think on 15/5/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#ifndef UniversalApp_Constants_h
#define UniversalApp_Constants_h

#ifdef APP_DEVELOPMENT_MODE
/*
 *  For development
 */

#else
/*
 *  For production
 */

#endif

/*
 *  Defines
 */

// For skin
#define loadSkinImage(name)   [[GlobalManager manager].skinManager imageForKey:name]
#define loadSkinColor(name)   [[GlobalManager manager].skinManager colorForKey:name]
#define loadSkinValue(name)   [[GlobalManager manager].skinManager resourceValueForKey:name]

#endif
