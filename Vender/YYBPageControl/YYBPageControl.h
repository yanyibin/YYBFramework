//
//  YYBPageControl.h
//  YYBKit
//
//  Created by Quincy Yan on 16/7/27.
//  Copyright © 2016年 YYBKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , YYBPageControlType) {
    YYBPageControlTypeCircle = 0,
    YYBPageControlTypeRect = 1,
};

@interface YYBPageControl : UIView

@property (nonatomic) YYBPageControlType type;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numbersOfPages;

@property (nonatomic,strong) UIColor *currentPageIndicatorColor;
@property (nonatomic,strong) UIColor *othersPageIndicatorColor;

@property (nonatomic) CGSize sizeForPageIndicator;
@property (nonatomic) CGFloat pageItemPadding;

@end
