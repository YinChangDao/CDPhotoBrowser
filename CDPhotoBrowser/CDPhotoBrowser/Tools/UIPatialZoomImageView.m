//
//  UIPatialZoomImageView.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/10.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIPatialZoomImageView.h"
@interface UIPatialZoomImageView()
//- (void)doubleTap:(UITouch *)touch;
@end
@implementation UIPatialZoomImageView
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(patialZoom:)];
        self.doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:self.doubleTapGesture];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)patialZoom:(UITapGestureRecognizer *)doubleTapGesture {
    if ([self.delegate respondsToSelector:@selector(doubleTapZoomWithGestureRecognize:)]) {
        [self.delegate doubleTapZoomWithGestureRecognize:doubleTapGesture];
    }
}

@end
