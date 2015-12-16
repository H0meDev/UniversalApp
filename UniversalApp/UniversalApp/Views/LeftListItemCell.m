//
//  LeftListItemCell.m
//  UniversalApp
//
//  Created by Think on 15/12/15.
//  Copyright © 2015年 think. All rights reserved.
//

#import "LeftListItemCell.h"

@interface LeftListItemCell ()
{
    UIImageView *_imageView;
}

@end

@implementation LeftListItemCell

- (void)cellDidLoad
{
    _imageView = [[UIImageView alloc]init];
    _imageView.backgroundColor = sysYellowColor();
    [self addSubview:_imageView];
}

- (void)cellWillAppear
{
    _imageView.frame = rectMake(0, 0, self.sizeWidth, self.sizeHeight);
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
        [UHTTPImage downloadImageWith:url callback:^(UIImage *image) {
            [_imageView performOnMainThread:@selector(setImage:) with:image];
        }];
    }
}

@end
