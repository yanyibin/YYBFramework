//
//  YYBPhotoBrowser.h
//  SavingPot365
//
//  Created by September on 2018/10/27.
//  Copyright © 2018 Tree,Inc. All rights reserved.
//

#import "YYBViewController.h"
#import "YYBPhotoBrowserTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYBPhotoBrowser : YYBViewController

@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic) NSInteger index;

// 允许删除照片
@property (nonatomic) BOOL isUsingDeletion;

@property (nonatomic,copy) void (^ deletImageHandler)(NSInteger index);

@property (nonatomic,copy) void (^ reloadImagesHandler)(void);
@property (nonatomic,strong) YYBPhotoBrowserTransition *transition;

@property (nonatomic,copy) CGRect (^ queryItemRectHandler)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
