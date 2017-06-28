//
//  UIPhotoTittleReusableView.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/4.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPhotoTittleReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *photoDate;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPicture;
@property (weak, nonatomic) IBOutlet UILabel *numberOfVideo;

- (void)setSectionPhotographInfoWithDic:(NSDictionary *)dic;
@end
