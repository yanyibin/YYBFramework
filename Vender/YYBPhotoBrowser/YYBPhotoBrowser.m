//
//  YYBPhotoBrowser.m
//  SavingPot365
//
//  Created by September on 2018/10/27.
//  Copyright © 2018 Tree,Inc. All rights reserved.
//

#import "YYBPhotoBrowser.h"
#import "YYBPhotoBrowserCollectionViewCell.h"
#import "YYBPhotoBrowserTransition.h"

@interface YYBPhotoBrowser () <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) YYBNavigationBarImageView *deleteBarButton;

@end

@implementation YYBPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _contentView = [UIView viewWithSuperView:self.view constraint:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    } configureHandler:nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = TRUE;
    [self.contentView addSubview:_collectionView];
    
    [_collectionView registerClass:[YYBPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"YYBPhotoBrowserCollectionViewCell"];
    
    _iconView = [UIImageView new];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.clipsToBounds = TRUE;
    _iconView.hidden = TRUE;
    [self.contentView addSubview:_iconView];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizerUpdate:)];
    [self.contentView addGestureRecognizer:_pan];
    
    _transition.pan = nil;
}

- (void)recognizerUpdate:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view];
    
    CGFloat scale = 1 - (translation.y / CGRectGetHeight(self.view.frame));
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            _transition.pan = pan;
            _collectionView.hidden = TRUE;
            _iconView.hidden = FALSE;
            
            id image = [_images objectAtIndex:[self index]];
            if ([image isKindOfClass:[UIImage class]]) {
                _iconView.image = image;
            } else {
                NSString *utf8 = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [_iconView sd_setImageWithURL:[NSURL URLWithString:utf8]];
            }
            
            _transition.imageResource = _iconView.image;
            _transition.fromImageRect = self.queryItemRectHandler([self index]);
            
            CGSize imageSize = [self aspectFitSizeWithSize:_iconView.image.size contentSize:self.view.frame.size];
            _iconView.frame = CGRectMake(0, (kScreenHeight - imageSize.height) / 2, imageSize.width, imageSize.height);
            
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            _iconView.center = CGPointMake(CGRectGetMidX(self.view.frame) + translation.x * scale, CGRectGetMidY(self.view.frame) + translation.y);
            _iconView.transform = CGAffineTransformMakeScale(scale, scale);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            _transition.finishImageRect = _iconView.frame;
            // 回复原状
            if (scale > 0.95f) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.iconView.center = self.view.center;
                    self.iconView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    self.iconView.hidden = TRUE;
                    self.collectionView.hidden = FALSE;
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (CGSize)aspectFitSizeWithSize:(CGSize)aspectSize contentSize:(CGSize)contentSize {
    CGSize result_size = aspectSize;
    if (aspectSize.width > contentSize.width || aspectSize.height > contentSize.height) {
        if (contentSize.width / contentSize.height > aspectSize.width / aspectSize.height) {
            result_size.height = contentSize.height;
            result_size.width = aspectSize.width * contentSize.height / aspectSize.height;
        } else {
            result_size.width = contentSize.width;
            result_size.height = contentSize.width / (aspectSize.width / aspectSize.height);
        }
    }
    return result_size;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_index < _images.count) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:FALSE];
    } else {
        if (_images.count > 0) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:FALSE];
        }
    }
}

- (void)configureNavigationView {
    [self.navigationBackBarButton setBarButtonImage:[[UIImage imageNamed:@"ic_navigation_back_white"] scale:2.0f] controlState:0];
    [self.navigationBackBarButton setBarButtonTextColor:[UIColor whiteColor] controlState:0];
    
    self.navigationBar.titleBarButton.label.text = [NSString stringWithFormat:@"1 / %ld",_images.count];
    self.navigationBar.titleBarButton.label.textColor = [UIColor whiteColor];
    self.navigationBar.titleBarButton.contentEdgeInsets = UIEdgeInsetsMake([UIDevice isIPhoneXSeries] ? 20.0f : 10.0f, 0, 0, 0);
    self.navigationBar.titleBarButton.label.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightSemibold];
    self.navigationBar.backgroundColor = [UIColor blackColor];
    
    if (self.isUsingDeletion == TRUE) {
        @weakify(self);
        _deleteBarButton = [YYBNavigationBarContainer imageViewWithConfigureHandler:^(YYBNavigationBarImageView *container, UIImageView *view) {
            container.contentSize = CGSizeMake(20.0f, 24.0f);
            container.contentEdgeInsets = UIEdgeInsetsMake([UIDevice isIPhoneXSeries] ? 20.0f : 10.0f, 0, 0, 22.5f);
            
            view.image = [UIImage imageNamed:@"ic_icon_delete"];
        } tapedActionHandler:^(YYBNavigationBarContainer *view) {
            @strongify(self);
            [YYBAlertView showAlertViewWithTitle:@"注意" detail:@"确定要删除这样照片吗?" cancelActionTitle:@"取消" confirmActionTitle:@"确定" confirmActionHandler:^{

                if (self.images.count == 1) {
                    [self.images removeAllObjects];
                    [self dismissViewControllerAnimated:TRUE completion:nil];
                } else {
                    [self.images removeObjectAtIndex:[self index]];
                }
                
                if (self.deletImageHandler) {
                    self.deletImageHandler([self index]);
                } else if (self.reloadImagesHandler) {
                    self.reloadImagesHandler();
                }
                
                [self scrollViewDidScroll:self.collectionView];
                [self.collectionView reloadData];
            }];
        }];
        
        self.navigationBar.rightBarContainers = @[_deleteBarButton];
    }
}

- (BOOL)navigationBackBarButtonHandler {
    _transition.pan = nil;
    [self dismissViewControllerAnimated:TRUE completion:nil];
    return FALSE;
}

- (NSString *)titleForNavigationBar {
    return @"返回";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(scrollView.frame);
    NSInteger index = scrollView.contentOffset.x / width;
    self.navigationBar.titleBarButton.label.text = [NSString stringWithFormat:@"%ld / %ld",index + 1,_images.count];
}

- (NSInteger)index {
    CGFloat width = CGRectGetWidth(_collectionView.frame);
    return _collectionView.contentOffset.x / width;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYBPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYBPhotoBrowserCollectionViewCell" forIndexPath:indexPath];
    id contents = [_images objectAtIndex:indexPath.row];
    if ([contents isKindOfClass:[UIImage class]]) {
        [cell renderItemWithImage:contents imageURL:NULL];
    } else if ([contents isKindOfClass:[NSString class]]) {
        [cell renderItemWithImage:NULL imageURL:contents];
    }
    
    @weakify(self);
    cell.oneTapedHandler = ^{
        @strongify(self);
        CGFloat alpha = self.navigationBar.alpha;
        if (alpha == 1.0f) {
            [UIView animateWithDuration:0.25f animations:^{
                self.navigationBar.alpha = 0.0f;
            }];
        } else {
            [UIView animateWithDuration:0.25f animations:^{
                self.navigationBar.alpha = 1.0f;
            }];
        }
    };
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

@end
