//
//  UIPhotoBrowserViewController.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIPhotoBrowserViewController.h"
#import "UILineListFlowLayout.h"
#import "UIPhotoBrowserFlowLayout.h"
#import "UIBrowserCollectionViewCell.h"
#import "UIListCollectionViewCell.h"
#import "UIPhotographViewController.h"
#import "UIPictureCollectionViewCell.h"
#import "Photo.h"

@interface UIPhotoBrowserViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate
>
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UICollectionView *browserCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property (nonatomic, strong) UIPhotoBrowserFlowLayout *browserLayout;
@property (nonatomic, strong) UILineListFlowLayout *listLayout;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@end

static NSString *browserID = @"browser";
static NSString *listID = @"list";
static BOOL isFirstIn = YES;
@implementation UIPhotoBrowserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.browserLayout = [[UIPhotoBrowserFlowLayout alloc] init];
    self.browserLayout.pageJumpBlock = ^(NSIndexPath *indexPath) {
        [weakSelf.listCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    };
    self.browserCollectionView.dataSource = self;
    self.browserCollectionView.delegate = self;
    self.browserCollectionView.scrollEnabled = YES;
    self.browserCollectionView.backgroundColor = [UIColor whiteColor];
    [self.browserCollectionView setCollectionViewLayout:self.browserLayout];
    
    self.listLayout = [[UILineListFlowLayout alloc] init];
    self.listLayout.pageJumpBlock = ^(NSIndexPath *indexPath){
        [weakSelf.browserCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    };
    self.listCollectionView.dataSource = self;
    self.listCollectionView.delegate = self;
    [self.listCollectionView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [self.listCollectionView setCollectionViewLayout:self.listLayout];
    
    [self.browserCollectionView registerClass:[UIBrowserCollectionViewCell class] forCellWithReuseIdentifier:browserID];
    [self.listCollectionView registerNib:[UINib nibWithNibName:@"UIListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:listID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentIndex = [NSIndexPath indexPathForItem:_lastIndex.item inSection:0];
}

// viewDidLayoutSubviews可能会被调用多次，为避免改变collectionView的当前显示cell后回到最初的现象，使用GCD的一次性代码，保证初始滚动只滚动一次
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (isFirstIn) {
        [self.browserCollectionView scrollToItemAtIndexPath:_currentIndex
                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                   animated:NO];
        [self.listCollectionView scrollToItemAtIndexPath:_currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    isFirstIn = NO;
}
- (IBAction)backToPhotograph:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 手势
- (void)showCurrentPhotoAlone:(UIGestureRecognizer *)gesture {
    self.naviView.hidden = !self.naviView.hidden;
    self.listCollectionView.hidden = !self.listCollectionView.hidden;
    self.browserCollectionView.backgroundColor = self.naviView.hidden ? [UIColor blackColor] : [UIColor whiteColor];
}

#pragma mark - 返回相册图片缩小的效果
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isFirstIn = YES;  // 将该静态全局变量置为yes否则viewDidLayoutSubviews内的代码在下次视图创建的时候将不会被调用
    
    NSInteger index = self.browserCollectionView.contentOffset.x / self.browserLayout.pageWidth;
    _currentIndex = [NSIndexPath indexPathForItem:index inSection:0];
    UIBrowserCollectionViewCell *currentCell = (UIBrowserCollectionViewCell *)[self.browserCollectionView cellForItemAtIndexPath:_currentIndex];
    UIImage *currentImage = currentCell.zoomScrollView.imageView.image;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = currentImage;
    [backgroundView addSubview:imageView];
    UIPhotographViewController *rootCtl = [self.navigationController.viewControllers firstObject];
    [rootCtl.view insertSubview:backgroundView atIndex:1];
    
    // 记下原来的contentOffset.y
    CGFloat lastOffsetY = rootCtl.albumCollectionView.contentOffset.y;
    // 如果回去的图片不在原界面的范围 原界面collectionView应该滚动调整位置
    NSIndexPath *scrollIndex = [NSIndexPath indexPathForItem:_currentIndex.item inSection:_lastIndex.section];
    [rootCtl.albumCollectionView scrollToItemAtIndexPath:scrollIndex atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    CGFloat currentOffsetY = rootCtl.albumCollectionView.contentOffset.y;
    CGFloat offsetGap = currentOffsetY - lastOffsetY;
    
    // 取出每个item间的间距
    CGFloat lineSpace = rootCtl.suspendLayout.minimumLineSpacing;
    CGFloat itmeSpace = rootCtl.suspendLayout.minimumInteritemSpacing;
    
    // 1.计算每行可以放多少的cell
    NSInteger numberOfCellInRow = SCREEN_WIDTH / _lastFrame.size.width;
    // 2.确定回去的frame
    // 2.1 X值
    NSInteger lastColumn = _lastIndex.item % numberOfCellInRow;
    NSInteger currentColumn = _currentIndex.item % numberOfCellInRow;
    NSInteger columnGap = currentColumn - lastColumn;
    int columnFlag = columnGap ? 1 : -1;
    CGFloat currentX = _lastFrame.origin.x + columnFlag * columnGap * _lastFrame.size.width + columnFlag * itmeSpace * columnGap;
    // 2.2 Y值
    NSInteger lastRow = _lastIndex.item / numberOfCellInRow;
    NSInteger currentRow = _currentIndex.item / numberOfCellInRow;
    NSInteger rowGap = currentRow - lastRow;
    int rowFlag = rowGap ? 1 : -1;
    CGFloat currentY = _lastFrame.origin.y + rowFlag * rowGap * _lastFrame.size.height + rowFlag * lineSpace * rowGap - offsetGap;
    
    CGRect currentFrame = CGRectMake(currentX, currentY, _lastFrame.size.width, _lastFrame.size.height);
    
    UIPictureCollectionViewCell *lastCell = (UIPictureCollectionViewCell *)[rootCtl.albumCollectionView cellForItemAtIndexPath:_lastIndex];
    lastCell.picture.image = _lastImage;         // 补上原图片
    UIPictureCollectionViewCell *newCell = (UIPictureCollectionViewCell *)[rootCtl.albumCollectionView cellForItemAtIndexPath:scrollIndex];
    newCell.picture.image = nil;                 // 将新图片清空
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.backgroundColor = [UIColor clearColor];
        imageView.frame = currentFrame;
    } completion:^(BOOL finished) {
        Photo *photo = _photoSection[scrollIndex.item];
        newCell.picture.image = photo.image;
        [backgroundView removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoSection.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.browserCollectionView) {
        UIBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:browserID forIndexPath:indexPath];
        Photo *photo = _photoSection[indexPath.item];
        [cell setPhotoInfoWithPhoto:photo];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurrentPhotoAlone:)];
        [cell.contentView addGestureRecognizer:tapGesture];
        [tapGesture requireGestureRecognizerToFail:cell.zoomScrollView.imageView.doubleTapGesture];
        return cell;
    } else {
        UIListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listID forIndexPath:indexPath];
        Photo *photo = _photoSection[indexPath.item];
        cell.listImage.image = photo.image;
        return cell;
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.listCollectionView) {
        [self.browserCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.listCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


@end
