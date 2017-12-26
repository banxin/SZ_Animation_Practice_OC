//
//  CircleShapeAnimationViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "CircleShapeAnimationViewController.h"

@interface CircleShapeAnimationViewController ()

@end

@implementation CircleShapeAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Shape 环形动画";
    
    [self createCirclyAnimation];
}

/*
 还有一种思路就是画两个圆，截取中间的环，对大圆进行颜色渐变填充，小圆clear所有颜色再去实现动画也能达到这样的效果。
 */
- (void)createCirclyAnimation
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(375/2-100, 667/2-100, 200, 200)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.repeatCount = MAXFLOAT;
    
    CAShapeLayer *layer = [self createShapeLayerNoFrame:[UIColor clearColor]];
    layer.path = path.CGPath;
    layer.lineWidth = 25.0;
    //圆的起始位置，默认为0
    layer.strokeStart = 0;
    //圆的结束位置，默认为1，如果值为0.75，且动画的end也为0.75，则显示3/4的圆
    layer.strokeEnd = 1;
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
}

- (CAShapeLayer *)createShapeLayerNoFrame:(UIColor *)color
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    //    layer.frame = CGRectMake(0, 0, 50, 50);
    //设置背景色
    //    layer.backgroundColor = [UIColor cyanColor].CGColor;
    //设置描边色
    layer.strokeColor = [UIColor blueColor].CGColor;
    //设置填充色
    layer.fillColor = color.CGColor;
    [self.view.layer addSublayer:layer];
    
    return layer;
}
































@end
