//
//  ViewController.m
//  CDPhotoBrowser
//
//  Created by YinChangdao on 2017/6/28.
//  Copyright © 2017年 ChangDao. All rights reserved.
//

#import "ViewController.h"
#import "UIPhotographViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickedTouchMe:(UIButton *)sender {
    UIPhotographViewController *photoAlbumCtl = [[UIPhotographViewController alloc] initWithNibName:@"UIPhotographViewController" bundle:nil];
    UINavigationController *naviCtl = [[UINavigationController alloc] initWithRootViewController:photoAlbumCtl];
    [self presentViewController:naviCtl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
