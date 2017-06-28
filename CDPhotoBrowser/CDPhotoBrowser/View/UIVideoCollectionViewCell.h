//
//  UIVideoCollectionViewCell.h
//  MaxiFly
//
//  Created by YinChangdao on 15/11/3.
//  Copyright © 2015年 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoScreenshot;
@property (weak, nonatomic) IBOutlet UILabel *timeDuration;

- (void)setCellInfoWithDic:(NSDictionary *)videoInfoDic;

@end
