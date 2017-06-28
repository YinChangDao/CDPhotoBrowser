//
//  UIPhotoZoomScrollView.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/10.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPatialZoomImageView.h"

@interface UIPhotoZoomScrollView : UIScrollView
@property (nonatomic, strong) UIPatialZoomImageView *imageView;
- (void)modifyImageViewLayout;
@end
