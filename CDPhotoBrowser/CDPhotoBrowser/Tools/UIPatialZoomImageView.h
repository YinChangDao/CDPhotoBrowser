//
//  UIPatialZoomImageView.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/10.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIPatialZoomImageViewDelegate <NSObject>

@optional
- (void)doubleTapZoomWithGestureRecognize:(UITapGestureRecognizer *)gestrueRecognize;

@end
@interface UIPatialZoomImageView : UIImageView

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, weak) id <UIPatialZoomImageViewDelegate> delegate;

@end
