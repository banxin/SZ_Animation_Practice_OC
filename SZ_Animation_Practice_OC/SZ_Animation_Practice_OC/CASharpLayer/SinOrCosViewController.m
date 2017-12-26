//
//  SinOrCosViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SinOrCosViewController.h"

@interface SinOrCosViewController ()

@end

@implementation SinOrCosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Shape 画曲线";

    UIBezierPath *path = [self startPoint:CGPointMake(50, 300) endPoint:CGPointMake(200, 300) controlPoint:CGPointMake(125, 200)];
    
    UIBezierPath *path1 = [self startPoint:CGPointMake(200, 300) endPoint:CGPointMake(350, 300) controlPoint:CGPointMake(275, 400)];
    
    CAShapeLayer *layer = [self createShapeLayer:[UIColor orangeColor]];
    layer.path = path.CGPath;
    
    CAShapeLayer *layer1 = [self createShapeLayer:[UIColor greenColor]];
    layer1.path = path1.CGPath;
}

/**
 配置贝塞尔曲线
 
 @param startPoint 起始点
 @param endPoint 结束点
 @param controlPoint 控制点
 @return UIBezierPath对象
 */
- (UIBezierPath *)startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    return path;
}

- (CAShapeLayer *)createShapeLayer:(UIColor *)color
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
