//
//  SZAnimationView.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZAnimationView.h"
#import "SZCircleLayer.h"
#import "SZTriangleLayer.h"
#import "SZRectangleLayer.h"
#import "SZWaterLayer.h"

@interface SZAnimationView ()

@property (nonatomic, strong) SZCircleLayer *circleLayer;
@property (nonatomic, strong) SZTriangleLayer *triangleLayer;
@property (nonatomic,strong)SZRectangleLayer *rectangleLayer1;
@property (nonatomic,strong)SZRectangleLayer *rectangleLayer2;
@property (nonatomic,strong)SZWaterLayer *waterLayer;

@end

@implementation SZAnimationView

-(void)beginAnimation
{
    [self.layer addSublayer:self.circleLayer];
    CGFloat dur = [self.circleLayer scaleAnimation:YES];
    [self performSelector:@selector(extrusionAnimation) withObject:nil afterDelay:dur];
}

-(void)extrusionAnimation
{
    CGFloat dur = [self.circleLayer extrusionAnimation];
    [self performSelector:@selector(triangleAnimation) withObject:nil afterDelay:dur];
}

-(void)triangleAnimation{
    
    [self.layer addSublayer:self.triangleLayer];
    CGFloat dur = [self.triangleLayer growAnimation];
    [self performSelector:@selector(roatationAnimation) withObject:nil afterDelay:dur];
    
}

-(void)roatationAnimation{
    [self.circleLayer scaleAnimation:NO];
    
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = AnimationTime * 2;
    rotationAnimation.removedOnCompletion = true;
    [self.layer addAnimation:rotationAnimation forKey:nil];
    [self performSelector:@selector(rectangleAnimation) withObject:nil afterDelay:(AnimationTime * 2)];
    
}

-(void)rectangleAnimation{
    [self.layer addSublayer:self.rectangleLayer1];
    CGFloat dur = [self.rectangleLayer1 rectangleAnimation:[UIColor greenColor]];
    [self performSelector:@selector(rectangleAnimation2) withObject:nil afterDelay:dur];
    
}

-(void)rectangleAnimation2{
    [self.layer addSublayer:self.rectangleLayer2];
    CGFloat dur = [self.rectangleLayer2 rectangleAnimation:[UIColor redColor]];
    [self performSelector:@selector(waterAnimation) withObject:nil afterDelay:dur];
    
}

-(void)waterAnimation{
    [self.layer addSublayer:self.waterLayer];
    CGFloat dur = [self.waterLayer waterAnimation];
    [self performSelector:@selector(finishAnimation) withObject:nil afterDelay:dur];
    
}

-(void)finishAnimation{
//    self.backgroundColor = [UIColor redColor];
    self.backgroundColor = [UIColor clearColor];
    [self.circleLayer removeFromSuperlayer];
    [self.triangleLayer removeFromSuperlayer];
    [self.rectangleLayer1 removeFromSuperlayer];
    [self.rectangleLayer2 removeFromSuperlayer];
    [self.waterLayer removeFromSuperlayer];
    
    
    
//    [UIView animateWithDuration:AnimationTime animations:^{
//        self.frame = [UIScreen mainScreen].bounds;
//
//    }completion:^(BOOL finished) {
//        [self finishAnimation2];
////        [self finishAnimation2];
//        NSLog(@">>>>>>>>:%@",NSStringFromCGRect(self.frame));
//    }];
}

-(void)finishAnimation2{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    label.center = CGPointMake(self.center.x, -200);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    [self addSubview:label];
    label.text = @"😄\n😄😄\n😄😄😄\n😄😄😄😄😄";
    
    [UIView animateWithDuration:AnimationTime * 3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.center = CGPointMake(self.center.x, self.center.y);
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (SZCircleLayer *)circleLayer
{
    if (!_circleLayer) {
        
        _circleLayer = [[SZCircleLayer alloc] init];
    }
    
    return _circleLayer;
}

- (SZTriangleLayer *)triangleLayer
{
    if (!_triangleLayer) {
        
        _triangleLayer = [[SZTriangleLayer alloc] init];
    }
    
    return _triangleLayer;
}

- (SZRectangleLayer *)rectangleLayer1
{
    if (!_rectangleLayer1) {
        
        _rectangleLayer1 = [[SZRectangleLayer alloc] init];
    }
    
    return _rectangleLayer1;
}

- (SZRectangleLayer *)rectangleLayer2
{
    if (!_rectangleLayer2) {
        
        _rectangleLayer2 = [[SZRectangleLayer alloc] init];
    }
    
    return _rectangleLayer2;
}

- (SZWaterLayer *)waterLayer
{
    if (!_waterLayer) {
        
        _waterLayer = [[SZWaterLayer alloc] init];
    }
    
    return _waterLayer;
}

@end



















