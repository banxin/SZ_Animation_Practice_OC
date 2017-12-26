//
//  SZWave.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZWave.h"

/**
 正弦曲线公式可表示为y=Asin(ωx+φ)+k：
 A，振幅，最高和最低的距离
 W，角速度，用于控制周期大小，单位x中的起伏个数
 K，偏距，曲线整体上下偏移量
 φ，初相，左右移动的值
 
 这个效果主要的思路是添加两条曲线 一条正玄曲线、一条余弦曲线 然后在曲线下添加深浅不同的背景颜色，从而达到波浪显示的效果
 */

#define BackGroundColor [UIColor colorWithRed:96/255.0f green:159/255.0f blue:150/255.0f alpha:1]
#define WaveColor1 [UIColor colorWithRed:136/255.0f green:199/255.0f blue:190/255.0f alpha:1]
#define WaveColor2 [UIColor colorWithRed:28/255.0 green:203/255.0 blue:174/255.0 alpha:1]

@interface SZWave ()
{
    //前面的波浪
    CAShapeLayer *_waveLayer1;
    CAShapeLayer *_waveLayer2;
    
    CADisplayLink *_disPlayLink;
    
    /**
     曲线的振幅
     */
    CGFloat _waveAmplitude;
    /**
     曲线角速度
     */
    CGFloat _wavePalstance;
    /**
     曲线初相
     */
    CGFloat _waveX;
    /**
     曲线偏距
     */
    CGFloat _waveY;
    
    /**
     曲线移动速度
     */
    CGFloat _waveMoveSpeed;
}


@end

@implementation SZWave

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
        [self buildData];
    }
    
    return self;
}

// 初始化UI
- (void)buildUI
{
    // 初始化波浪
    // 底层
    _waveLayer1 = [CAShapeLayer layer];
    _waveLayer1.fillColor = WaveColor1.CGColor;
    _waveLayer1.strokeColor = WaveColor1.CGColor;
    [self.layer addSublayer:_waveLayer1];
    
    // 上层
    _waveLayer2 = [CAShapeLayer layer];
    _waveLayer2.fillColor = WaveColor2.CGColor;
    _waveLayer2.strokeColor = WaveColor2.CGColor;
    [self.layer addSublayer:_waveLayer2];
    
    // self.layer 画成圆
    self.layer.cornerRadius = self.bounds.size.width / 2.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = BackGroundColor;
}

// 初始化数据
- (void)buildData
{
    // 振幅
    _waveAmplitude = 10;
    // 角速度
    _wavePalstance = M_PI / self.bounds.size.width;
    // 偏距
    _waveY = self.bounds.size.height;
    // 初相
    _waveX = 0;
    // x轴移动速度
    _waveMoveSpeed = _wavePalstance * 10;
    // 以屏幕刷新速度为周期刷新曲线的位置
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave:)];
    [_disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateWave:(CADisplayLink *)link
{
    _waveX += _waveMoveSpeed;
    [self updateWaveY];
    [self updateWave1];
    [self updateWave2];
}

// 更新偏距的大小 直到达到目标偏距 让wave有一个匀速增长的效果
- (void)updateWaveY
{
    CGFloat targetY = self.bounds.size.height - _progress * self.bounds.size.height;
    if (_waveY < targetY) {
        _waveY += 2;
    }
    if (_waveY > targetY ) {
        _waveY -= 2;
    }
}

- (void)updateWave1
{
    // 波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    CGFloat endX = 0;
    
    // 正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        
        endX = x;
        
        CGFloat y = 0;
        
        y = _waveAmplitude * cos(_wavePalstance * x + _waveX) + _waveY;
        
        if (x == 0) {
            
            [wavePath moveToPoint:CGPointMake(x, y)];
            
        } else {
            
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(self.bounds);
    
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    _waveLayer1.path = wavePath.CGPath;
}

- (void)updateWave2
{
    // 波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    CGFloat endX = 0;
    
    // 正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        
        endX = x;
        
        CGFloat y = 0;
        
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX) + _waveY;
        
        if (x == 0) {
            
            [wavePath moveToPoint:CGPointMake(x, y)];
            
        } else {
            
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(self.bounds);
    
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    _waveLayer2.path = wavePath.CGPath;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
}

- (void)stop
{
    if (_disPlayLink) {
        [_disPlayLink invalidate];
        _disPlayLink = nil;
    }
}

- (void)dealloc
{
    [self stop];
    if (_waveLayer1) {
        [_waveLayer1 removeFromSuperlayer];
        _waveLayer1 = nil;
    }
    if (_waveLayer2) {
        [_waveLayer2 removeFromSuperlayer];
        _waveLayer2 = nil;
    }
}

@end
