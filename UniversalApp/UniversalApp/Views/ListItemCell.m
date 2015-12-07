//
//  ListItemCell.m
//  UniversalApp
//
//  Created by Think on 15/12/7.
//  Copyright © 2015年 think. All rights reserved.
//

#import "ListItemCell.h"

@interface ListItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ListItemCell

- (void)cellDidLoad
{
    [self titleLabel];
    [self contentLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = rectMake(8, 8, screenWidth() - 16, 21);
    titleLabel.backgroundColor = sysClearColor();
    titleLabel.font = systemFont(17);
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (_contentLabel) {
        return _contentLabel;
    }
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.frame = rectMake(8, 37, screenWidth() - 16, 54);
    contentLabel.backgroundColor = sysClearColor();
    contentLabel.font = systemFont(14);
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    return _contentLabel;
}

#pragma mark - Methods

- (void)setCellData:(id)cellData
{
    if (checkValidNSDictionary(cellData)) {
        NSDictionary *dict = (NSDictionary *)cellData;
        self.titleLabel.text = dict[@"title"];
        self.contentLabel.text = dict[@"content"];
        
        CGFloat height = self.contentLabel.contentHeight;
        self.contentLabel.sizeHeight = height;
        self.sizeHeight = self.contentLabel.bottom + 8;
    }
}

@end
