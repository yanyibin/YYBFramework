//
//  YYBPhotoSelectionsView.h
//  SavingPot365
//
//  Created by Sniper on 2018/11/3.
//  Copyright © 2018 Tree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYBPhotoSelectionsView : UIView

@property (nonatomic,strong) UIButton *finishButton;
- (void)renderButtonWithImagesCount:(NSInteger)count;

@property (nonatomic,copy) void (^ finishSelectedHandler)(void);

@end

NS_ASSUME_NONNULL_END
