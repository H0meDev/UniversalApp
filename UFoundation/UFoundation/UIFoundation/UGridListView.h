//
//  UGridListView.h
//  UFoundation
//
//  Created by Think on 15/12/10.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"

@class UGridListView;

@protocol UGridListViewDelegate <NSObject>

@end

@protocol UGridListViewDataSource <NSObject>

@end

@interface UGridListView : UIView

@property (nonatomic, weak) id<UGridListViewDelegate> delegate;
@property (nonatomic, weak) id<UGridListViewDataSource> dataSource;

@end
