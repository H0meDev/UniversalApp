//
//  LeftListItemCell.m
//  UniversalApp
//
//  Created by Think on 15/12/15.
//  Copyright © 2015年 think. All rights reserved.
//

#import "LeftListItemCell.h"

@interface LeftListItemCell ()

@property (nonatomic, strong) UIImageView *imageUView;
@property (nonatomic, strong) UIImageView *imageDView;

@end

@implementation LeftListItemCell

- (void)cellDidLoad
{
    if (_imageUView) {
        [_imageUView removeFromSuperview];
        _imageUView = nil;
    }
    
    if (_imageDView) {
        [_imageDView removeFromSuperview];
        _imageDView = nil;
    }
    
    [self imageUView];
    [self imageDView];
}

- (void)cellNeedsUpdate
{
    [self cellDidLoad];
}

- (UIImageView *)imageUView
{
    if (_imageUView) {
        return _imageUView;
    }
    
    CGFloat height = screenHeight() - statusHeight() - naviHeight() - tabHeight();
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = rectMake(0, 0, screenWidth(), height / 2.);
    imageView.backgroundColor = sysYellowColor();
    [self addSubview:imageView];
    _imageUView = imageView;
    
    return _imageUView;
}

- (UIImageView *)imageDView
{
    if (_imageDView) {
        return _imageDView;
    }
    
    CGFloat height = screenHeight() - statusHeight() - naviHeight() - tabHeight();
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = rectMake(0, height / 2., screenWidth(), height / 2.);
    imageView.backgroundColor = sysYellowColor();
    [self addSubview:imageView];
    _imageDView = imageView;
    
    return _imageDView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCellData:(NSString *)url
{
    if (checkValidNSString(url)) {
        [self.imageUView setNetworkImage:url placeholder:nil];
        [self.imageDView setNetworkImage:url placeholder:nil];
    }
}

@end
