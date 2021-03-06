//
//  UIScrollView+YYBRefreshFooter.h
//  YYBRefreshView
//
//  Created by Aokura on 2017/11/22.
//  Copyright © 2017年 Beauty, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBRefreshBaseView.h"
#import "YYBRefreshFooterView.h"
#import "YYBRefreshBottomView.h"

@interface UIScrollView (YYBRefreshFooter)

@property (nonatomic,strong) YYBRefreshFooterView *footer;
- (void)removeFooterView;

- (void)addRefreshFooterWithHandler:(YYBRefreshStartRefreshHandler)startRefreshHandler;
- (void)addRefreshFooterWithClass:(Class)viewClass handler:(YYBRefreshStartRefreshHandler)startRefreshHandler;
- (void)addRefreshFooterWithClass:(Class)viewClass handler:(YYBRefreshStartRefreshHandler)startRefreshHandler height:(CGFloat)height;

@end
