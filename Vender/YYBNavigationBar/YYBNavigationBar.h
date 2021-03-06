//
//  YYBNavigationBar.h
//  YYBNavigationBar
//
//  Created by Aokura on 2018/9/27.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBNavigationBarContainer+Create.h"

@interface YYBNavigationBar : UIView

@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UIImageView *contentView;
@property (nonatomic,strong) UIView *bottomLayerView;

@property (nonatomic,strong) YYBNavigationBarLabel *titleBarButton;
@property (nonatomic,strong) YYBNavigationBarContainer *titleBarContainer;

@property (nonatomic,strong) NSArray *leftBarContainers;
@property (nonatomic,strong) NSArray *rightBarContainers;

@end
