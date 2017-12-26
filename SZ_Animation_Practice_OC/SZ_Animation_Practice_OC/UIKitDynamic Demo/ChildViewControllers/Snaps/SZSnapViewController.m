//
//  SZSnapViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/8.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZSnapViewController.h"

/*
 吸附(snap)行为非常简单,它让物体动态地移到屏幕的另一个地方.
 
 在示例应用中,这种行为是由轻按手势触发的.无论用户再屏幕的什么地方轻按,指定的视图都会跳到指定的地方.每个 UISnapBehavior 都只与一个物体相关联.初始化 UISnapBehavior 时必须指定物体的移动重点.还可指定属性 damping,它决定了物体被吸附时的弹跳粒度
 
 2.注意点
 
 如果要想达到如效果图那般连续的吸附行为,必须将之前的吸附行为从力学动画器中移除,然后再添加.否则不会有此效果
 */

@interface SZSnapViewController ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIImageView *imageView_first;

@end

@implementation SZSnapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [self.view addSubview:self.imageView_first];
    [self addTapGes];
}

- (void)addTapGes
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [self.view addGestureRecognizer:tapGes];
}

- (void)tapMethod:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.imageView_first snapToPoint:point];
    
    // 定了物体被吸附时的弹跳粒度
    snapBehavior.damping = 0.75f;
    [self.dynamicAnimator removeAllBehaviors];  // 如果要进行连续的吸附行为,那么就必须把之前的吸附行为从力学动画器中移除
    [self.dynamicAnimator addBehavior:snapBehavior];
}

#pragma mark - lazy load

- (UIDynamicAnimator *)dynamicAnimator
{
    if (nil == _dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _dynamicAnimator;
}

- (UIImageView *)imageView_first
{
    if (nil == _imageView_first) {
        _imageView_first = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei"]];
        _imageView_first.frame = CGRectMake(100, 100, 100, 100);
    }
    return _imageView_first;
}

@end


















