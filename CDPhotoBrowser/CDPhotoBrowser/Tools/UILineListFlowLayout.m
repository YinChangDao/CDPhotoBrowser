//
//  UILineListFlowLayout.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UILineListFlowLayout.h"

static const CGFloat MLItemH = 12.5;
static const CGFloat MLItemW = 17;

@implementation UILineListFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(MLItemW, MLItemH);
    CGFloat inset = (self.collectionView.frame.size.width - MLItemW) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *origin = [super layoutAttributesForElementsInRect:rect];
    NSArray *attriArray = [[NSArray alloc] initWithArray:origin copyItems:YES];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attrs in attriArray) {
        CGFloat itemCenterX = attrs.center.x;
        CGFloat scale =1 + (17 - ABS(itemCenterX - centerX))/17;
        attrs.zIndex = 0;
        if (ABS(itemCenterX - centerX)< 17) {
            attrs.zIndex = 50;
            if (ABS(itemCenterX - centerX)< 10) {
                attrs.zIndex = 100;
            }
            attrs.transform3D = CATransform3DMakeScale(scale, scale, 1);
        }
    }
    return [attriArray copy];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    UICollectionViewLayoutAttributes *middleAttribute;
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
            middleAttribute = attrs;
        }
    }
    self.pageJumpBlock(middleAttribute.indexPath);
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
@end
