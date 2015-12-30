//
//  LeftListItemCell.m
//  UniversalApp
//
//  Created by Think on 15/12/15.
//  Copyright © 2015年 think. All rights reserved.
//

#import "LeftListItemCell.h"

@interface LeftListItemCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LeftListItemCell

- (void)cellDidLoad
{
    [self imageView];
}

- (void)cellNeedsUpdate
{
    if (_imageView) {
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    
    [self cellDidLoad];
}

- (UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    
    CGFloat height = screenHeight() - statusHeight() - naviHeight() - tabHeight();
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = rectMake(0, 0, screenWidth(), height);
    imageView.backgroundColor = sysYellowColor();
    [self addSubview:imageView];
    _imageView = imageView;
    
    return _imageView;
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
    _imageView.image = nil;
    
    if (checkValidNSString(url)) {
        [UHTTPImage downloadImageWith:url callback:^(UHTTPImageItem *item) {
            if (_imageView) {
                [_imageView setImage:item.image];
            }
        }];
    }
}

@end
