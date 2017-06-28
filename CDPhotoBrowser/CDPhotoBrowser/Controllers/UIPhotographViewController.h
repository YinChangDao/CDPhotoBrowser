//
//  UIPhotographViewController.h
//  MaxiFly
//
//  Created by YinChangdao on 15/11/3.
//  Copyright © 2015年 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISuspendHeaderFlowLayout.h"

@interface UIPhotographViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (nonatomic, strong) UISuspendHeaderFlowLayout *suspendLayout;

@end
