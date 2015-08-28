//
//  UITableView+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UITableView+UAExtension.h"

@implementation UITableView (UAExtension)

- (id)cellWith:(NSString *)identifier
{
    return [self dequeueReusableCellWithIdentifier:identifier];
}

- (id)cellWith:(NSString *)identifier ForIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

@end
