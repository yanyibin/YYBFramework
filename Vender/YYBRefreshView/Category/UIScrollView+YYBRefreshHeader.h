//
//  UIScrollView+YYBRefreshHeader.h
//  YYBRefreshView
//
//  Created by Aokura on 2017/11/22.
//  Copyright © 2017年 Beauty, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBRefreshBaseView.h"
#import "YYBRefreshHeaderView.h"
#import "YYBRefreshTopView.h"

@interface UIScrollView (YYBRefreshHeader)

@property (nonatomic,strong) YYBRefreshHeaderView *header;
- (void)removeHeaderView;

- (void)addRefreshHeaderWithHandler:(YYBRefreshStartRefreshHandler)startRefreshHandler;
- (void)addRefreshHeaderWithClass:(Class)viewClass handler:(YYBRefreshStartRefreshHandler)startRefreshHandler;
- (void)addRefreshHeaderWithClass:(Class)viewClass handler:(YYBRefreshStartRefreshHandler)startRefreshHandler height:(CGFloat)height;

@end
