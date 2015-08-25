//
//  UImagePickerControllerController.h
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UViewController.h"

@protocol UImagePickerControllerControllerDelegate <NSObject>

// seletedArray is array of ALAsset object
- (void)imagePickerDidSelected:(NSArray *)seletedArray;

@end

@interface UImagePickerControllerController : UViewController

@property (nonatomic, weak) id<UImagePickerControllerControllerDelegate> delegate;

@end
