//
//  YYBRefreshBaseDoneView.h
//  YYB_Framework
//
//  Created by Aokura on 2018/7/3.
//  Copyright © 2018年 Tree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBRefreshBaseDoneView : UIView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic,strong,readonly) UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets scrollEdgeInsets;

- (void)renderOriginalEdgeInsets;
- (void)renderAnimationEdgeInsets;

@end
