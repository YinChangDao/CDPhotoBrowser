//
//  UIBrowserCollectionViewCell.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIBrowserCollectionViewCell.h"

@implementation UIBrowserCollectionViewCell

- (void)setPhotoInfoWithPhoto:(Photo *)photo {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.zoomScrollView = [[UIPhotoZoomScrollView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.zoomScrollView];
    self.zoomScrollView.imageView.image = photo.image;
}

@end
