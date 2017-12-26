//
//  MatchManViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/24.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "MatchManViewController.h"

@interface MatchManViewController ()

@end

@implementation MatchManViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"火柴人";
    
    [self useBezierPathAndShapeLayer];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 0.5, 100)];
    
    line.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:line];
    
    [self addDottedLineToView:line];
}

/**
 使用UIBezierPath和CAShapeLayer画图
 */
- (void)useBezierPathAndShapeLayer
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(175, 100)];
    
    // 画圆
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 线条颜色
    shapeLayer.strokeColor = [UIColor colorWithRed:147/255.0 green:231/255.0 blue:182/255.0 alpha:1].CGColor;
    // 填充颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
}

- (void)addDottedLineToView:(UIView *)view
{
    // 虚线边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    borderLayer.bounds = view.bounds;
    
    borderLayer.position = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
//
//    borderLayer.lineWidth = 0.5f ;
    
    borderLayer.lineWidth = 1.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(view.frame))];
    borderLayer.path = path.CGPath;
    
    // 虚线lineLength lineSpace
    borderLayer.lineDashPattern = @[@4, @2];
    
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor redColor].CGColor;
    
    [view.layer addSublayer:borderLayer];
}

@end
