//
//  YYBNavigationBarImageView.m
//  YYBNavigationBar
//
//  Created by Aokura on 2018/9/28.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import "YYBNavigationBarImageView.h"

@implementation YYBNavigationBarImageView

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _imageView = [UIImageView new];
    [self addSubview:_imageView];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
