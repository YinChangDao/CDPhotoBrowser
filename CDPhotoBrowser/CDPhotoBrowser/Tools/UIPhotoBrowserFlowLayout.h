//
//  UIPhotoBrowserFlowLayout.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPhotoBrowserFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) CGFloat flickVelocity;
@property (nonatomic, copy) void(^pageJumpBlock)(NSIndexPath *indexPath);
@end
