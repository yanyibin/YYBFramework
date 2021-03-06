//
//  YYBPhotoSelectionsView.m
//  SavingPot365
//
//  Created by Sniper on 2018/11/3.
//  Copyright © 2018 Tree,Inc. All rights reserved.
//

#import "YYBPhotoSelectionsView.h"

@interface YYBPhotoSelectionsView ()

@end

@implementation YYBPhotoSelectionsView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    _finishButton = [UIButton buttonWithSuperView:self constraint:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 15.0f);
        make.size.mas_equalTo(CGSizeMake(80.0f, 30.0f));
        make.top.equalTo(self).offset(10.0f);
    } configureButtonHandler:^(UIButton *button) {
        button.backgroundColor = [UIColor globalColor];
        [button setTitle:@"完成" forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightSemibold];
        [button cornerRadius:4.0f];
    } tapedHandler:^(UIButton *sender) {
        @strongify(self);
        if (self.finishSelectedHandler) {
            self.finishSelectedHandler();
        }
    }];
    
    [self topLayerWithColor:[UIColor colorWithHexInteger:0xEBEBEB] height:0.5f edgeInsets:UIEdgeInsetsZero];
    
    return self;
}

- (void)renderButtonWithImagesCount:(NSInteger)count {
    if (count == 0) {
        _finishButton.enabled = FALSE;
        [_finishButton setTitle:@"完成" forState:0];
    } else {
        _finishButton.enabled = TRUE;
        [_finishButton setTitle:[NSString stringWithFormat:@"完成(%@)",@(count).stringValue] forState:0];
    }
}

@end
