//
//  YYBRefreshBottomView.h
//  YYBRefreshView
//
//  Created by Aokura on 2017/11/22.
//  Copyright © 2017年 Beauty, Inc. All rights reserved.
//

#import "YYBRefreshFooterView.h"

static const NSString * BTRV_BOTTOM_INITIALIZE = @"上拉加载更多";
static const NSString * BTRV_BOTTOM_PULLING = @"松开加载更多";
static const NSString * BTRV_BOTTOM_REFRESHING = @"正在加载";

@interface YYBRefreshBottomView : YYBRefreshFooterView

- (void)resetTitle:(NSString *)title status:(YYBRefreshStatus)status;

@end
