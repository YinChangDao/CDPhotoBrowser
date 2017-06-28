//
//  UISuspendHeaderFlowLayout.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/4.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UISuspendHeaderFlowLayout.h"

@implementation UISuspendHeaderFlowLayout
// 只要显示的边界发生改变就重新布局：
// 内部会重新调用layoutAttributesForElementsInRect:方法，获取所有cell的布局属性
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.sectionInset = UIEdgeInsetsMake(0, 2, 10, 2);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumLineSpacing = 2;
    self.minimumInteritemSpacing = 2;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attriArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *missingSection = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in attriArray) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSection addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttrbutes in attriArray) {
        if ([layoutAttrbutes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSection removeIndex:layoutAttrbutes.indexPath.section];
        }
    }
    [missingSection enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (attributes) {
            [attriArray addObject:attributes];
        }
    }];
    for (UICollectionViewLayoutAttributes *attributes in attriArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            NSIndexPath *lastItmeIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection - 1) inSection:attributes.indexPath.section];
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection > 0) {
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItmeIndexPath];
            } else {
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                CGFloat y = CGRectGetMaxY(attributes.frame) + self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                lastItemAttributes = firstItemAttributes;
            }
            CGRect rect = attributes.frame;
            CGFloat offset = self.collectionView.contentOffset.y + 34;  // 34为导航栏的高度
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
            CGFloat maxY = MAX(offset, headerY);
            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            rect.origin.y = MIN(maxY, headerMissingY);
            attributes.frame = rect;
            attributes.zIndex = 1024;
        }
    }
    
    return [attriArray copy];
}

@end
