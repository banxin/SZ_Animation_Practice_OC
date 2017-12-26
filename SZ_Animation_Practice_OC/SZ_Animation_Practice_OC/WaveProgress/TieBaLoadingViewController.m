//
//  TieBaLoadingViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "TieBaLoadingViewController.h"
#import "SZTieBaLoading.h"

@interface TieBaLoadingViewController ()

@end

@implementation TieBaLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"仿贴吧 Loading";
    
    [SZTieBaLoading showInView:self.view];
}

@end
