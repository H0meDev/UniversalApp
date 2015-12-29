//
//  UListGridView.h
//  UFoundation
//
//  Created by Think on 15/12/10.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"

@class UListGridView;

@protocol UListGridViewDelegate <NSObject>

@end

@protocol UListGridViewDataSource <NSObject>

@end

@interface UListGridView : UIView

@property (nonatomic, weak) id<UListGridViewDelegate> delegate;
@property (nonatomic, weak) id<UListGridViewDataSource> dataSource;

@end
