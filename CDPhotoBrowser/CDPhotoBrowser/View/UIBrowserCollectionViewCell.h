//
//  UIBrowserCollectionViewCell.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPhotoZoomScrollView.h"
#import "Photo.h"

@interface UIBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIPhotoZoomScrollView *zoomScrollView;

- (void)setPhotoInfoWithPhoto:(Photo *)photo;

@end
