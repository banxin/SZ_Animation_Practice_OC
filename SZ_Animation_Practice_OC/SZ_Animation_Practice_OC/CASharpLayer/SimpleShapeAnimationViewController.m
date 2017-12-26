//
//  SimpleShapeAnimationViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SimpleShapeAnimationViewController.h"

@interface SimpleShapeAnimationViewController ()

@end

@implementation SimpleShapeAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Shape 简单动画";
    
    [self createLineAnimation];
    
    [self createCurve];
    
    [self createCurveWithAnimation2];
}

- (void)createLineAnimation
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 100)];
//    [path addLineToPoint:CGPointMake(375/2, 667/4)];
    [path addLineToPoint:CGPointMake(300, 100)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //每次动画的持续时间
    animation.duration = 5;
    //动画起始位置
    animation.fromValue = @(0);
    //动画结束位置
    animation.toValue = @(1);
    //动画重复次数
    animation.repeatCount = MAXFLOAT;
    // 是否执行逆动画
    animation.autoreverses = YES;
    
    CAShapeLayer *layer = [self createShapeLayerNoFrame:[UIColor orangeColor]];
    layer.path = path.CGPath;
    layer.lineWidth = 2.0;
    layer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f].CGColor;
    //设置图形的弧度
    //    layer.strokeStart = 0;
    //    layer.strokeEnd = 0;
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
    //注：由于UIBezierPath已经设置路径，所以动画的路径就不需要再次设置，只需要设置起始0与结束1就行，有需要可以设置动画结束后是否需要返回原位置。
}

- (void)createCurve
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //起始点
    [path moveToPoint:CGPointMake(50, 667/4)];
    //结束点、两个控制点
    [path addCurveToPoint:CGPointMake(330, 667/4) controlPoint1:CGPointMake(200, 10) controlPoint2:CGPointMake(185, 667/2)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 5;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    
    CAShapeLayer *layer = [self createShapeLayerNoFrame:[UIColor clearColor]];
    layer.path = path.CGPath;
    layer.lineWidth = 2.0;
    layer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.5f].CGColor;
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
}

/*
 使用了 strokeEnd、strokeStart和lineWidth 三个属性，第一个动画用了strokeEnd这个属性的值范围是0-1，动画显示了从0到1之间每一个值对这条曲线的影响，strokeStart的方法则是相反的，如果把这两个值首先都设置成0.5然后慢慢改变成0和1的时候就会变成第二个动画，配合lineWidth则曲线会慢慢变粗，这里的很多属性都是支持动画的。
 */
- (void)createCurveWithAnimation2
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //起始点
    [path moveToPoint:CGPointMake(50, 667/2)];
    //结束点、两个控制点
    [path addCurveToPoint:CGPointMake(330, 667/2) controlPoint1:CGPointMake(125, 200) controlPoint2:CGPointMake(185, 450)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = 5;
    animation.fromValue = @(0.5);
    animation.toValue = @(0);
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.duration = 5;
    animation2.fromValue = @(0.5);
    animation2.toValue = @(1);
    animation2.repeatCount = MAXFLOAT;
    animation2.autoreverses = YES;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation3.duration = 5;
    animation3.fromValue = @(1);
    animation3.toValue = @(10);
    animation3.repeatCount = MAXFLOAT;
    animation3.autoreverses = YES;
    
    CAShapeLayer *layer = [self createShapeLayerNoFrame:[UIColor clearColor]];
    layer.path = path.CGPath;
    layer.lineWidth = 2.0;
    layer.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5f].CGColor;
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
    [layer addAnimation:animation2 forKey:@"strokeEndAnimation2"];
    [layer addAnimation:animation3 forKey:@"strokeEndAnimation3"];
}

- (CAShapeLayer *)createShapeLayerNoFrame:(UIColor *)color
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    //    layer.frame = CGRectMake(0, 0, 50, 50);
    //设置背景色
    //    layer.backgroundColor = [UIColor cyanColor].CGColor;
    //设置描边色
    layer.strokeColor = [UIColor blackColor].CGColor;
    //设置填充色
    layer.fillColor = color.CGColor;
    [self.view.layer addSublayer:layer];
    
    return layer;
}

@end
