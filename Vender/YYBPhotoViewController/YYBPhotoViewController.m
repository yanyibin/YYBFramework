//
//  YYBPhotoViewController.m
//  SavingPot365
//
//  Created by Aokura on 2018/9/27.
//  Copyright © 2018年 Tree,Inc. All rights reserved.
//

#import "YYBPhotoViewController.h"
#import "YYBPhotoContentView.h"
#import "YYBPhotoCollectionViewCell.h"
#import "PHAsset+YYBPhoto.h"
#import "YYBPhotoSectionView.h"
#import "YYBPhotoSelectionsView.h"

@interface YYBPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YYBPhotoContentViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) PHFetchResult *result;
@property (nonatomic,strong) YYBPhotoContentView *contentView;
@property (nonatomic,strong) UIView *shadeView; // 黑色遮罩

@property (nonatomic,strong) YYBNavigationBarLabel *cancelBarButton;
@property (nonatomic,strong) YYBPhotoSectionView *sectionView;
@property (nonatomic,strong) YYBPhotoSelectionsView *selectionsView;

@property (nonatomic,strong) NSMutableArray *selectedAssets;

@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,strong) YYBAlertView *alertView;

@end

@implementation YYBPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _semaphore = dispatch_semaphore_create(0);
    _queue = dispatch_queue_create("YYBPHOTOVIEWCONTROLLER.CONCURRENT.QUEUE", DISPATCH_QUEUE_CONCURRENT);
    
    self.view.clipsToBounds = TRUE;
    _selectedAssets = [NSMutableArray new];
    
    @weakify(self);
    _collectionView = [UICollectionView collectionViewWithDelagateHandler:self superView:self.view constraint:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    } registerClassNames:@[@"YYBPhotoCollectionViewCell"] configureHandler:^(UICollectionView *view, UICollectionViewFlowLayout *layout) {
        @strongify(self);
        view.backgroundColor = [UIColor whiteColor];
        view.contentInset = UIEdgeInsetsMake([self heightForNavigationBar], 1.0f, 64.0f, 1.0f);
    }];
    
    _shadeView = [UIView viewWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f] superView:self.view constraint:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    } configureHandler:^(UIView *view) {
        view.hidden = TRUE;
        view.alpha = 0.0f;
    }];
    
    _contentView = [YYBPhotoContentView viewWithSuperView:self.view constraint:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top).offset([self heightForNavigationBar]);
        make.height.mas_equalTo(320.0f);
    } configureHandler:^(YYBPhotoContentView *view) {
        @strongify(self);
        view.delegate = self;
    }];
    
    _selectionsView = [YYBPhotoSelectionsView viewWithSuperView:self.view constraint:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50.0f + ([UIDevice isIPhoneXSeries] ? kBottomOffsetForX : 0));
    } configureHandler:^(YYBPhotoSelectionsView *view) {
        @strongify(self);
        view.hidden = [self isAppendingImagesEnable] == FALSE;
    }];
    
    _selectionsView.finishSelectedHandler = ^{
        @strongify(self);
        if (self.isImageRequired == TRUE) {
            [self doRequireImages];
        } else {
            if (self.imageAssetsQueryHandler) {
                self.imageAssetsQueryHandler(self.selectedAssets);
            }
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
    };
    
    [self takePhotoAlbumDatasource];
}

- (void)doRequireImages {
    dispatch_async(_queue, ^{
        NSMutableArray *results = [NSMutableArray new];
        dispatch_async_on_main_queue(^{
            self.alertView = [YYBAlertView showWaitingAlertView];
        });
        
        @weakify(self);
        for (NSInteger index = 0; index < self.selectedAssets.count; index ++) {
            PHAsset *asset = [self.selectedAssets objectAtIndex:index];
            [asset produceImageWithTargetSize:CGSizeZero completionHandler:^(UIImage *image, NSString *filename) {
                @strongify(self);
                [results addObject:image];
                dispatch_semaphore_signal(self.semaphore);
            }];
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async_on_main_queue(^{
            [self.alertView closeAlertView];
            if (self.imageAssetsQueryHandler) {
                self.imageAssetsQueryHandler(results);
            }
            [self dismissViewControllerAnimated:TRUE completion:nil];
        });
    });
}

- (void)configureNavigationView {
    @weakify(self);
    _cancelBarButton = [YYBNavigationBarLabel labelWithConfigureHandler:^(YYBNavigationBarLabel *container, UILabel *view) {
        container.contentEdgeInsets = UIEdgeInsetsMake([UIDevice isIPhoneXSeries] ? 20.0f : 10.0f, 15.0f, 0, 0);
        
        view.text = @"取消";
        view.textColor = [UIColor blackColor];
        view.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightLight];
    } tapedActionHandler:^(YYBNavigationBarContainer *view) {
        @strongify(self);
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }];
    
    _sectionView = [[YYBPhotoSectionView alloc] init];
    _sectionView.contentSize = CGSizeMake(200.0f, 40.0f);
    _sectionView.contentEdgeInsets = UIEdgeInsetsMake([UIDevice isIPhoneXSeries] ? 20.0f : 10.0f, 0, 0, 0);
    _sectionView.librarySelectedHandler = ^(BOOL isSelected) {
        @strongify(self);
        [UIView animateWithDuration:0.25f animations:^{
            if (isSelected) {
                self.shadeView.hidden = FALSE;
                self.shadeView.alpha = 1.0f;
                self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.frame));
            } else {
                self.shadeView.alpha = 0.0f;
                self.contentView.transform = CGAffineTransformIdentity;
            }
        } completion:^(BOOL finished) {
            if (isSelected == FALSE) {
                self.shadeView.hidden = TRUE;
            }
        }];
    };
    
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationBar.titleBarContainer = _sectionView;
    self.navigationBar.leftBarContainers = @[_cancelBarButton];
    self.navigationBar.bottomLayerView.backgroundColor = [UIColor colorWithHexInteger:0xEBEBEB];
}

- (void)photoContentViewSelectedResults:(PHFetchResult *)assetsResult collection:(PHAssetCollection *)collection {
    _result = assetsResult;
    [_sectionView sectionSelectedHandler];
    _sectionView.contentLabel.text = collection.localizedTitle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)takePhotoAlbumDatasource {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];

    // Videos,Bursts,Hidden,Camera Roll,Selfies,Panoramas,ecently Deleted,Time-lapse,Favorites,Recently Added,Slo-mo,Screenshots,Portrait,Live Photos,Animated,Long Exposure
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    _contentView.results = result;
    
    @weakify(self);
    [result enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * stop) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            @strongify(self);
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            [self photoContentViewSelectedResults:fetchResult collection:collection];
            *stop = YES;
        }
    }];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = (CGRectGetWidth(self.view.frame) - 5.0f) / 4;
    return CGSizeMake(size, size);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYBPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYBPhotoCollectionViewCell" forIndexPath:indexPath];
    PHAsset *asset = [_result objectAtIndex:indexPath.row];
    
    @weakify(self);
    cell.checkSelectionHandler = ^BOOL{
        @strongify(self);
        return [self selectionStatusWithAsset:asset];
    };
    
    cell.checkAppendEnableHandler = ^BOOL{
        @strongify(self);
        return [self isAppendingImagesEnable];
    };
    
    cell.selectActionHandler = ^{
        @strongify(self);
        BOOL isSelected = [self selectionStatusWithAsset:asset];
        if (isSelected) {
            [self.selectedAssets removeObject:asset];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YYBPHOTOSELECTEDNOTIFICATION" object:nil];
        } else {
            if (self.selectedAssets.count < self.maxAllowedImages) {
                [self.selectedAssets addObject:asset];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YYBPHOTOSELECTEDNOTIFICATION" object:nil];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YYBPHOTOSAPPENDNOTIFICATION" object:nil];
        [self.selectionsView renderButtonWithImagesCount:self.selectedAssets.count];
    };
    
    [cell renderItemWithAsset:asset selectionStatus:[self selectionStatusWithAsset:asset] isMultipleImagesRequired:_isMultipleImagesRequired isAppendImageEnable:[self isAppendingImagesEnable]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _result.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [_result objectAtIndex:indexPath.row];
    if (_isMultipleImagesRequired == FALSE) {
        if (self.imageAssetQueryHandler) {
            self.imageAssetQueryHandler(asset);
        }
        [self dismissViewControllerAnimated:TRUE completion:nil];
    } else {
        // 查看图片浏览器
    }
}

- (BOOL)selectionStatusWithAsset:(PHAsset *)asset {
    if (_isMultipleImagesRequired == FALSE) {
        return FALSE;
    }
    return [_selectedAssets containsObject:asset];
}

- (BOOL)isAppendingImagesEnable {
    if (_isMultipleImagesRequired == TRUE) {
        return _selectedAssets.count != _maxAllowedImages;
    } else {
        return TRUE;
    }
}

@end
