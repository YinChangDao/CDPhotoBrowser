//
//  Photo.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/4.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

@end
