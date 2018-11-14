//
//  YYBIndicator.h
//  SavingPot365
//
//  Created by Aokura on 2018/5/29.
//  Copyright © 2018年 Tree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBIndicator : UIView

@property (nonatomic,readwrite) UIColor *activeTintColor;
@property (nonatomic,readwrite) UIColor *deactiveTintColor;

@property (nonatomic,readwrite) float progress;

@end
