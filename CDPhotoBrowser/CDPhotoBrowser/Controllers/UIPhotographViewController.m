//
//  UIPhotographViewController.m
//  MaxiFly
//
//  Created by YinChangdao on 15/11/3.
//  Copyright © 2015年 IOS. All rights reserved.
//

#import "UIPhotographViewController.h"
#import "UIPictureCollectionViewCell.h"
#import "UIVideoCollectionViewCell.h"
#import "UIPhotoTittleReusableView.h"
#import "UIPhotoBrowserViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Photo.h"

@interface UIPhotographViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *albumNaviView;
@property (nonatomic, strong) NSMutableArray *albumsArray;

@end

static NSString *pictureID = @"picture";
static NSString *headerID = @"header";
@implementation UIPhotographViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 关闭navigationController的侧滑手势pop功能
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    _albumsArray = [NSMutableArray array];
    // 制造 5 组图片
    for (int i = 0; i < 5; i++) {
        NSMutableArray<Photo *> *imageArr = [NSMutableArray array];
        for (int j = 1; j < 18; j++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"timg0%d%d.jpeg", j / 10, j % 10]];
            Photo *photo = [[Photo alloc] initWithImage:image];
            [imageArr addObject:photo];
        }
        [_albumsArray addObject:imageArr];
    }
    
    [self setupUI];
}

- (void)setupUI {
    self.suspendLayout = [[UISuspendHeaderFlowLayout alloc] init];
    
    [self.albumCollectionView setCollectionViewLayout:self.suspendLayout];
    
    self.albumCollectionView.dataSource = self;
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.backgroundColor = [UIColor whiteColor];
    self.albumCollectionView.contentInset = UIEdgeInsetsMake(34, 0, 0, 0);
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 34);
    [self.albumNaviView insertSubview:effectView atIndex:0];
    
    // 注册cell
    [self.albumCollectionView registerNib:[UINib nibWithNibName:@"UIPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:pictureID];
    
    // 注册段头视图
    [self.albumCollectionView registerNib:[UINib nibWithNibName:@"UIPhotoTittleReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToConsoleView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击放大图片
- (void)displayPictureWithIndexPath:(NSIndexPath *)indexPath {
    UIPictureCollectionViewCell *currentCell = (UIPictureCollectionViewCell *)[self.albumCollectionView cellForItemAtIndexPath:indexPath];
    CGRect convertRect = [[currentCell superview] convertRect:currentCell.frame toView:self.view];
    UIImage *currentImage = currentCell.picture.image;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:convertRect];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = currentImage;
    [backgroundView addSubview:imageView];
    [self.view insertSubview:backgroundView aboveSubview:self.albumCollectionView];
    
    currentCell.picture.image = nil;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        backgroundView.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        // 下载大图
        UIPhotoBrowserViewController *browserCtl = [[UIPhotoBrowserViewController alloc] initWithNibName:@"UIPhotoBrowserViewController" bundle:nil];
        browserCtl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        browserCtl.photoSection = _albumsArray[indexPath.section];
        browserCtl.lastIndex = indexPath;
        browserCtl.lastFrame = convertRect;
        browserCtl.lastImage = currentImage;
        [self.navigationController pushViewController:browserCtl animated:NO];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _albumsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_albumsArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureID forIndexPath:indexPath];
    Photo *photo = _albumsArray[indexPath.section][indexPath.item];
    cell.picture.image = photo.image;
    return cell;
}

// 补充视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UIPhotoTittleReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    
    // 为了演示按日期分组和头视图悬停的效果，这里随机产生一个日期，图片和视频的个数也使用假数据
    NSString *date = [NSString stringWithFormat:@"%u月%u日", arc4random() % 12 + 1, arc4random() % 30];
    NSString *photo = [NSString stringWithFormat:@"%u", arc4random() % 20];
    NSString *video = [NSString stringWithFormat:@"%u", arc4random() % 20];
    NSDictionary *dic = @{@"date" : date, @"photoNo" : photo, @"videoNo" : video};
    [resuableView setSectionPhotographInfoWithDic:dic];
    return resuableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self displayPictureWithIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 26);
}

// 每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(131, 131);
}

// 控制段内容与边界的距离
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 2, 15, 2);
//}

// 维持当前列所需的最大距离
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 2;
//}
//
//// 返回最小行距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 3;
//}




@end
