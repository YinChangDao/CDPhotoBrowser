//
//  UIPhotoZoomScrollView.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/10.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIPhotoZoomScrollView.h"
@interface UIPhotoZoomScrollView () <UIScrollViewDelegate, UIPatialZoomImageViewDelegate>

- (CGRect)zoomRectScale:(CGFloat)scale withCenter:(CGPoint)center;

@end

@implementation UIPhotoZoomScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIPatialZoomImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.delegate = self;
        self.imageView.delegate = self;
        self.maximumZoomScale = 4.0f;
        // minimumZoomScale maximumZoomScale default is 1.0;
    }
    return self;
}

- (CGRect)zoomRectScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
- (void)modifyImageViewLayout {
    CGSize boundsSize = self.bounds.size;
    CGRect imageRect = self.imageView.frame;
    if (imageRect.size.width < boundsSize.width) {
        imageRect.origin.x = floorf((boundsSize.width - imageRect.size.width) / 2.0);
    } else {
        imageRect.origin.x = 0;
    }
    
    if (imageRect.size.height < boundsSize.height) {
        imageRect.origin.y = floorf((boundsSize.height - imageRect.size.height) / 2.0);
    } else {
        imageRect.origin.y = 0;
    }
    self.imageView.frame = imageRect;
}

#pragma mark - UIPatialZoomImageViewDelegate
- (void)doubleTapZoomWithGestureRecognize:(UITapGestureRecognizer *)gestrueRecognize {
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [gestrueRecognize locationInView:gestrueRecognize.view];
        touchPoint = [self convertPoint:touchPoint fromView:gestrueRecognize.view];
        CGRect zoomRect = [self zoomRectScale:self.maximumZoomScale withCenter:touchPoint];
        [self zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self modifyImageViewLayout];
}
@end
