//
//  YYBNavigationBarButton.h
//  YYBNavigationBar
//
//  Created by Aokura on 2018/9/27.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import "YYBNavigationBarContainer.h"

@interface YYBNavigationBarButton : YYBNavigationBarContainer

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,copy) void (^ buttonTapedActionHandler)(YYBNavigationBarContainer *view);

@end
