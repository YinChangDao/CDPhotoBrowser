//
//  UIPhotoBrowserFlowLayout.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIPhotoBrowserFlowLayout.h"
@implementation UIPhotoBrowserFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 20;
}

- (CGFloat)pageWidth {
    return self.itemSize.width + self.minimumLineSpacing;
}
- (CGFloat)flickVelocity {
    return 0.3;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 计算出要实现collectionView一次只能翻一页的效果的停留点
    CGFloat rawPageValue = self.collectionView.contentOffset.x / self.pageWidth;
    CGFloat currentPage = velocity.x > 0.0 ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = velocity.x > 0.0 ? ceil(rawPageValue) : floor(rawPageValue);
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.x = nextPage * self.pageWidth;
    } else {
        proposedContentOffset.x = round(rawPageValue) * self.pageWidth;
    }
    // 计算collectionView停留后当前的indexPath
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.bounds.size;
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    UICollectionViewLayoutAttributes *attribute = [array lastObject];
    NSIndexPath *indexPath = attribute.indexPath;
    if (self.pageJumpBlock) {
        self.pageJumpBlock(indexPath);
    }
    return proposedContentOffset;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}

@end
