//
//  BaseTextField.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UImageView.h"
#import "UITextField+UAExtension.h"

@interface UTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets textInsets; // Default is 0,0,0,0
@property (nonatomic, retain, readonly) UImageView *backgroundView;

@end
