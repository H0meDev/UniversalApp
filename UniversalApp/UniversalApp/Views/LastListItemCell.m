//
//  LastListItemCell.m
//  UniversalApp
//
//  Created by Think on 15/9/18.
//  Copyright © 2015年 think. All rights reserved.
//

#import "LastListItemCell.h"

@interface LastListItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;


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

- (void)setCellData:(id)cellData
{
    if (checkValidNSDictionary(cellData)) {
        NSDictionary *dict = (NSDictionary *)cellData;
        self.labelTitle.text = dict[@"title"];
        self.labelContent.text = dict[@"content"];
        
        CGFloat height = self.labelContent.contentHeight;
        self.labelContent.sizeHeight = height;
        self.sizeHeight = self.labelContent.paddingBottom + 8;
    }
}

@end
