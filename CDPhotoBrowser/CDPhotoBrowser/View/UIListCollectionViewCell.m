//
//  UIListCollectionViewCell.m
//  PhotographAlbum
//
//  Created by YinChangdao on 15/11/5.
//  Copyright © 2015年 YinChangdao. All rights reserved.
//

#import "UIListCollectionViewCell.h"

@implementation UIListCollectionViewCell

- (void)awakeFromNib {
    
    self.listImage.layer.borderWidth = 1;
    self.listImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

@end
