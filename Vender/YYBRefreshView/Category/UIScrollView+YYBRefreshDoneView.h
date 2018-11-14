//
//  UIScrollView+YYBRefreshDoneView.h
//  YYB_Framework
//
//  Created by Aokura on 2018/7/4.
//  Copyright © 2018年 Tree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBRefreshBaseDoneView.h"
#import "YYBRefreshDoneView.h"

@interface UIScrollView (YYBRefreshDoneView)

@property (nonatomic,strong) YYBRefreshBaseDoneView *doneView;
- (void)removeDoneView;

- (void)addRefreshDoneView;
- (void)addRefreshDoneViewWithClass:(Class)viewClass;
- (void)addRefreshDoneViewWithClass:(Class)viewClass height:(CGFloat)height;

@end
