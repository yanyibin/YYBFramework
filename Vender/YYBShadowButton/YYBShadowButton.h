//
//  YYBShadowButton.h
//  SavingPot365
//
//  Created by Aokura on 2018/9/10.
//  Copyright © 2018年 Tree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBShadowButton : UIView

@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UIButton *actionButton;

@property (nonatomic,copy) void (^ buttonTapedHandler)(void);

@end
