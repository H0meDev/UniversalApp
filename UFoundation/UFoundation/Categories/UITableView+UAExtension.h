//
//  UITableView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UIScrollView+UAExtension.h"

@interface UITableView (UAExtension)

- (id)cellWith:(NSString *)identifier;
- (id)cellWith:(NSString *)identifier ForIndexPath:(NSIndexPath *)indexPath;

@end
