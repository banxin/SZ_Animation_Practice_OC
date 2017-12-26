//
//  SZComplexAnimationViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZComplexAnimationViewController.h"
#import "SZAnimationView.h"

@interface SZComplexAnimationViewController ()

@property (nonatomic, strong) SZAnimationView *animationView;

@end

@implementation SZComplexAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.animationView = [[SZAnimationView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.animationView.center = self.view.center;
    [self.view addSubview:self.animationView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{    
    [self.animationView beginAnimation];
}

@end



















