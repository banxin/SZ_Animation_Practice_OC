//
//  DrawShapeViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "DrawShapeViewController.h"

@interface DrawShapeViewController ()

@end

@implementation DrawShapeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Shape 画图";
    
    [self draw];
}

- (void)draw
{
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        // 线条颜色
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        // 绘制矩形
        shapeLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 100, 100, 100)].CGPath;
        
        [self.view.layer addSublayer:shapeLayer];
    }
    
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        // 线条颜色
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        // 绘制圆形路径
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(200, 100, 100, 100)].CGPath;
        
        [self.view.layer addSublayer:shapeLayer];
    }
    
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        // 线条颜色
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        // 绘制自带圆角的路径
        shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 260, 100, 100) cornerRadius:30].CGPath;
        
        [self.view.layer addSublayer:shapeLayer];
    }
    
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        // 线条颜色
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        // 指定矩形某一个角加圆角（代码示例为左上角）
        shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(200, 260, 100, 100) byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(50, 50)].CGPath;
        
        [self.view.layer addSublayer:shapeLayer];
    }
    
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, 450)];
        [path addLineToPoint:CGPointMake(0, 550)];
        [path addLineToPoint:CGPointMake(self.view.bounds.size.width, 550)];
        [path addLineToPoint:CGPointMake(self.view.bounds.size.width, 450)];
        [path addQuadCurveToPoint:CGPointMake(0, 450) controlPoint:CGPointMake(self.view.bounds.size.width / 2, 400)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        // 线条颜色
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.3f].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        // 画一个拱形
        shapeLayer.path = path.CGPath;
        
        [self.view.layer addSublayer:shapeLayer];
    }
}






























@end
