//
//  WaveLoadingViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/24.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "WaveLoadingViewController.h"
#import "SZWaveLoadingView.h"

@interface WaveLoadingViewController ()

/*
 自定义loading
 */
@property (nonatomic, strong) SZWaveLoadingView *loadingView;

@end

@implementation WaveLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"波浪loading动画";
    
    [self initLoadingView];
    
    [_loadingView startLoading];
}

/**
 初始化loading
 */
- (void)initLoadingView
{
    _loadingView = [SZWaveLoadingView loadingView];
    
    [self.view addSubview:_loadingView];
    
    _loadingView.center = self.view.center;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [_loadingView startLoading];
//}

@end
















