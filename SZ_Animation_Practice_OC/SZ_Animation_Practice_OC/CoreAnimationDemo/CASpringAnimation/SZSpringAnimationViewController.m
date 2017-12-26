//
//  SZSpringAnimationViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZSpringAnimationViewController.h"

/*
 CASpringAnimation弹性动画
 
 CASpringAnimation的属性(iOS9新加)
 
 // 理解下面的属性的时候可以结合现实物理现象,比如把它想象成一个弹簧上挂着一个金属小球
 // 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
 @property CGFloat mass;
 // 刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
 @property CGFloat stiffness;
 // 阻尼系数,阻止弹簧伸缩的系数,阻尼系数越大,停止越快,可以认为它是阻力系数
 @property CGFloat damping;
 // 初始速率,动画视图的初始速度大小速率为正数时,速度方向与运动方向一致,速率为负数时,速度方向与运动方向相反.
 @property CGFloat initialVelocity;
 // 结算时间,只读.返回弹簧动画到停止时的估算时间，根据当前的动画参数估算通常弹簧动画的时间使用结算时间比较准确
 @property(readonly) CFTimeInterval settlingDuration;
 
 */

@interface SZSpringAnimationViewController ()

@property (nonatomic, strong) UILabel *demoView;

@end

@implementation SZSpringAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.demoView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _demoView.center = CGPointMake(self.view.center.x + 120, self.view.center.y - 120);
    _demoView.text = @"DEMO";
    _demoView.textColor = [UIColor whiteColor];
    _demoView.textAlignment = NSTextAlignmentCenter;
    _demoView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_demoView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 64 + 20, 100, 60)];
    
    btn.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
    [btn setTitle:@"弹性动画" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)animationBegin:(UIButton *)btn
{
    CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
    
    // 阻尼系数,阻止弹簧伸缩的系数,阻尼系数越大,停止越快,可以认为它是阻力系数
    spring.damping = 5;
    // 刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
    spring.stiffness = 100;
    // 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    spring.mass = 1;
    // 初始速率,动画视图的初始速度大小速率为正数时,速度方向与运动方向一致,速率为负数时,速度方向与运动方向相反.
    spring.initialVelocity = 0;
    spring.duration = spring.settlingDuration;//settlingDuration 结算时间,只读.返回弹簧动画到停止时的估算时间，根据当前的动画参数估算通常弹簧动画的时间使用结算时间比较准确
    spring.fromValue = @(self.demoView.center.y);
    spring.toValue = @(self.demoView.center.y + 200);
//    spring.autoreverses = YES;
    spring.fillMode = kCAFillModeForwards;
    
    [self.demoView.layer addAnimation:spring forKey:@"spring"];
}

@end
























