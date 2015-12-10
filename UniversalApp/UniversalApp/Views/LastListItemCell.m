//
//  LastListItemCell.m
//  UniversalApp
//
//  Created by Think on 15/9/18.
//  Copyright © 2015年 think. All rights reserved.
//

#import "LastListItemCell.h"

@interface LastListItemCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;


@end

@implementation LastListItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
