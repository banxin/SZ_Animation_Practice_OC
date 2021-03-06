//
//  SZCircleLayer.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZCircleLayer.h"

@interface SZCircleLayer ()

@property (nonatomic, strong) UIBezierPath *smallPath;
@property (nonatomic, strong) UIBezierPath *bigPath;
@property (nonatomic, strong) UIBezierPath *verticalPath;
@property (nonatomic, strong) UIBezierPath *horizontalPath;

@end

const CGFloat AnimationTime = 0.3;

@implementation SZCircleLayer

- (instancetype)init {
    
    if (self == [super init]) {
        
        self.fillColor = [UIColor redColor].CGColor;
        self.path = self.smallPath.CGPath;
    }
    
    return self;
}

-(CGFloat)scaleAnimation:(BOOL)toBig
{
    
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"path"];
    if (toBig) {
        base.fromValue = (__bridge id)self.smallPath.CGPath;
        base.toValue = (__bridge id)self.bigPath.CGPath;
    }else{
        base.fromValue = (__bridge id)self.bigPath.CGPath;
        base.toValue = (__bridge id)self.smallPath.CGPath;
    }
    
    base.duration = AnimationTime;
    base.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    base.fillMode = kCAFillModeForwards;
    base.removedOnCompletion = NO;
    [self addAnimation:base forKey:nil];
    return base.duration;
}

// 压扁动画,计算动画完成的时间
- (CGFloat)extrusionAnimation
{
    CABasicAnimation *horizontal = [CABasicAnimation animationWithKeyPath:@"path"];
    horizontal.fromValue = (__bridge id)self.bigPath.CGPath;
    horizontal.toValue = (__bridge id)self.horizontalPath.CGPath;
    horizontal.beginTime = 0.0;
    horizontal.duration = AnimationTime;
    
    CABasicAnimation *vertical = [CABasicAnimation animationWithKeyPath:@"path"];
    vertical.fromValue = (__bridge id)self.horizontalPath.CGPath;
    vertical.toValue = (__bridge id)self.verticalPath.CGPath;
    // 该处的处理只是为了逆动画能够变回圆，只要比horizontal后执行即可
    vertical.beginTime = horizontal.beginTime + horizontal.duration;
//    vertical.beginTime = horizontal.beginTime + horizontal.duration / 2;
//    vertical.beginTime = horizontal.beginTime + 0.001;
    vertical.duration = AnimationTime;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[horizontal,vertical];
    group.autoreverses = YES;
    group.repeatCount = 2;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self addAnimation:group forKey:nil];
    
    return (horizontal.duration + vertical.duration) * 2;
}

-(UIBezierPath *)smallPath{
    if (_smallPath == nil) {
        _smallPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 50, 0, 0)];
    }
    return _smallPath;
}

-(UIBezierPath *)bigPath{
    if (_bigPath == nil) {
        _bigPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
    }
    return _bigPath;
}

-(UIBezierPath *)verticalPath{
    if (_verticalPath == nil) {
        _verticalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, -10, 80, 120)];
    }
    return _verticalPath;
}

-(UIBezierPath *)horizontalPath{
    if (_horizontalPath == nil) {
        _horizontalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, 10, 120, 80)];
    }
    return _horizontalPath;
}

@end


















