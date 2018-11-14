//
//  YYBNavigationBarContainer.h
//  YYBNavigationBar
//
//  Created by Aokura on 2018/9/28.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBNavigationBarContainer : UIControl

@property (nonatomic) UIEdgeInsets contentEdgeInsets;
@property (nonatomic) CGSize contentSize;

@property (nonatomic,copy) void (^ tapedActionHandler)(YYBNavigationBarContainer *view);

@end
