//
//  WaveProgressViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "WaveProgressViewController.h"
#import "SZWaveProgress.h"

@interface WaveProgressViewController ()
{
    SZWaveProgress *_waveProgress;
}

@end

@implementation WaveProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"波浪进度动画";
    
    [self setupUI];
}

- (void)setupUI
{
    _waveProgress = [[SZWaveProgress alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _waveProgress.center = self.view.center;
    [self.view addSubview:_waveProgress];
    _waveProgress.progress = 0.0f;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_waveProgress.frame) + 50, self.view.bounds.size.width - 2*50, 30)];
    [slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setMinimumTrackTintColor:[UIColor colorWithRed:96/255.0f green:159/255.0f blue:150/255.0f alpha:1]];
    [self.view addSubview:slider];
}

- (void)sliderMethod:(UISlider*)slider
{
    _waveProgress.progress = slider.value;
}

























@end
