//
//  Photo.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/4.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

@end
