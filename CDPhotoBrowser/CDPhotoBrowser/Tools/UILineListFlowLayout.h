//
//  UILineListFlowLayout.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILineListFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, copy) void(^pageJumpBlock)(NSIndexPath *indexPath);
@end
