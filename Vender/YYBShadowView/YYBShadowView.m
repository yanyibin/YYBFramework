//
//  YYBShadowView.m
//  SavingPot365
//
//  Created by September on 2018/10/7.
//  Copyright © 2018 Tree,Inc. All rights reserved.
//

#import "YYBShadowView.h"

@implementation YYBShadowView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _shadowView = [UIView viewWithSuperView:self constraint:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    } configureHandler:nil];
    
    _contentView = [UIView viewWithSuperView:self.shadowView constraint:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    } configureHandler:^(UIView *view) {
        view.backgroundColor = [UIColor whiteColor];
    }];
    
    return self;
}

@end
