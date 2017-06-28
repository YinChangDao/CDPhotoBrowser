//
//  UIPhotoTittleReusableView.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/4.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIPhotoTittleReusableView.h"

@implementation UIPhotoTittleReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 26);
    [self insertSubview:effectView atIndex:0];
}

- (void)setSectionPhotographInfoWithDic:(NSDictionary *)dic {
    self.photoDate.text = dic[@"date"];
    self.numberOfPicture.text = dic[@"photoNo"];
    self.numberOfVideo.text = dic[@"videoNo"];
}

@end
