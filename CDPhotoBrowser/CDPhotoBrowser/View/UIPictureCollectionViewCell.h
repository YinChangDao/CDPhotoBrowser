//
//  UIPictureCollectionViewCell.h
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/4.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;

- (void)setPhotoInfoWithDic:(NSDictionary *)photoInfoDic;

@end
