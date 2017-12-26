//
//  SZRectangleLayer.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZRectangleLayer.h"
#import "SZCircleLayer.h"

@interface SZRectangleLayer ()

@property (nonatomic, strong) UIBezierPath *rectPath;

@end

@implementation SZRectangleLayer

-(instancetype)init{
    if (self = [super init]) {
        self.fillColor = [UIColor clearColor].CGColor;
        self.lineWidth = 5;
        self.path = self.rectPath.CGPath;
    }
    return self;
}

-(CGFloat)rectangleAnimation:(UIColor *)color{
    self.strokeColor = color.CGColor;
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = AnimationTime * 2;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    [self addAnimation:animation forKey:nil];
    return animation.duration;
}

-(UIBezierPath *)rectPath{
    if (_rectPath == nil) {
        _rectPath = [UIBezierPath bezierPath];
        [_rectPath moveToPoint:CGPointMake(-0, 80)];
        [_rectPath addLineToPoint:CGPointMake(0, -20)];
        [_rectPath addLineToPoint:CGPointMake(100, -20)];
        [_rectPath addLineToPoint:CGPointMake(100, 80)];
        [_rectPath closePath];
    }
    return  _rectPath;
}

@end
