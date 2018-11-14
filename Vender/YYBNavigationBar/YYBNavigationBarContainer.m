//
//  YYBNavigationBarContainer.m
//  YYBNavigationBar
//
//  Created by Aokura on 2018/9/28.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import "YYBNavigationBarContainer.h"

@implementation YYBNavigationBarContainer

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(tapedAction) forControlEvents:1<<6];
    
    return self;
}

- (void)tapedAction
{
    if (self.tapedActionHandler)
    {
        self.tapedActionHandler(self);
    }
}

@end
