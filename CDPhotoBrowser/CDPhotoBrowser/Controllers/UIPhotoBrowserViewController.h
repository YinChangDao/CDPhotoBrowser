//
//  UIPhotoBrowserViewController.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) NSArray *photoSection;
@property (nonatomic, strong) NSIndexPath *lastIndex;
@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, strong) UIImage *lastImage;

@end
