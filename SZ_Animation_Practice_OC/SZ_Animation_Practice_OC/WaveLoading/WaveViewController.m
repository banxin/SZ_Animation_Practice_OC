//
//  WaveViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "WaveViewController.h"

@interface WaveViewController ()

/*
 以下为测试属性
 */

@property (nonatomic, strong) UIView *sinView;

@property (nonatomic, assign) CGFloat frequency;

// 波浪相关的参数
@property (nonatomic, assign) CGFloat waveWidth;
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat waveMid;
@property (nonatomic, assign) CGFloat maxAmplitude;

@property (nonatomic, assign) CGFloat phase;

@property (nonatomic, assign) CGFloat phaseCos;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *waveSinLayer;

@property (nonatomic, strong) CAShapeLayer *waveCosLayer;

@end

@implementation WaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"正弦和余弦波浪";
    
    [self drawSinView];
    
    [self startLoading];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self startLoading];
//}

- (void)drawSinView
{
    _sinView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    
    _sinView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    
    [self.view addSubview:_sinView];
    
    self.waveHeight = CGRectGetHeight(_sinView.bounds);
    self.waveWidth  = CGRectGetWidth(_sinView.bounds);
    
    // 波峰的高度
    self.maxAmplitude = self.waveHeight * 0.3;
    
    // 曲线的左右伸缩
    self.frequency = 1;
    // 左右移动的距离
    self.phase = 0;
    self.phaseCos = 0;
    
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        // 线条颜色
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        // 填充颜色
        shapeLayer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5].CGColor;
        shapeLayer.lineWidth = 5;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.path = [self createCosPath].CGPath;
        
        self.waveCosLayer = shapeLayer;
        
        [_sinView.layer addSublayer:shapeLayer];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 线条颜色
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    // 填充颜色
    shapeLayer.fillColor = [UIColor colorWithRed:147/255.0 green:231/255.0 blue:182/255.0 alpha:0.5].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = [self createSinPath].CGPath;
    
    self.waveSinLayer = shapeLayer;
    
    [_sinView.layer addSublayer:shapeLayer];
}

- (void)startLoading
{
    [_displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(updateWave:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
}

- (void)updateWave:(CADisplayLink *)displayLink
{
    self.phase += 8;//逐渐累加初相
    self.waveSinLayer.path = [self createSinPath].CGPath;
    
    self.phaseCos += 10;
    self.waveCosLayer.path = [self createCosPath].CGPath;
}

/**
 x值在(-2π , 2π )的范围类，在[-1, 1]之间变化。
 
 正弦曲线为例，它可以表示为y=Asin(ωx+φ)+k
 
 A–振幅，即波峰的高度，最高点到最低点的高度。
 (ωx+φ)–相位，反应了变量y所处的位置。
 φ–初相，x=0时的相位，反映在坐标系上则为图像的左右移动。
 k–偏距，反映在坐标系上则为图像的上移或下移。
 ω–角速度，控制正弦周期(单位角度内震动的次数)。
 */
- (UIBezierPath *)createSinPath
{
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    CGFloat endX = 0;
    
    for (CGFloat x = 0; x < self.waveWidth + 1; x += 1) {
        
        endX = x;
        
        // self.maxAmplitude 振幅
        // 360.0 / _waveWidth * (x  * M_PI / 180.0) * self.frequency  角速度，单位角度内震动的次数，值越大，峰越陡，反之，则缓
        // + self.phase * M_PI / 180.0) 初相 左右移动
        // + self.maxAmplitude 偏距 上下移动
        /*
         在这里我们设定了两个正弦曲线上的点的横坐标间距是1，现在来解释一下通过横坐标x来得出y的计算过程：
         
         y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
         
         第一个self.maxAmplitude表示曲线的波峰值，360.0 / _waveWidth计算出单位间距1pixel代表的度数，x * M_PI / 180表示将横坐标值转换为角度。self.frequency表示角速度，即单位面积内波动次数，波浪的大小。self.phase * M_PI/ 180代表上面公式中的初相，通过规律的变化初相，可以制造出曲线上的点动起来的效果，self.maxAmplitude代表偏距，由于我们需要让波浪曲线的波峰在layer的范围内显示，所以需要将整个曲线向下移动波峰大小的单位，因为CALayer使用左手坐标系，所以向下移动需要加上波峰的大小。
         */
        CGFloat y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180.0) * self.frequency + self.phase * M_PI / 180.0) + self.maxAmplitude;
        
        if (x == 0) {
            
            [wavePath moveToPoint:CGPointMake(x, y)];
            
        } else {
            
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(_sinView.bounds) + 10;
    
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    return wavePath;
}

- (UIBezierPath *)createCosPath
{
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    CGFloat endX = 0;
    
    for (CGFloat x = 0; x < self.waveWidth + 1; x += 1) {
        
        endX = x;
        
        // self.maxAmplitude 振幅
        // 360.0 / _waveWidth * (x  * M_PI / 180.0) * self.frequency  角速度，单位角度内震动的次数，值越大，峰越陡，反之，则缓
        // + self.phase * M_PI / 180.0) 初相 左右移动
        // + self.maxAmplitude 偏距 上下移动
        /*
         在这里我们设定了两个正弦曲线上的点的横坐标间距是1，现在来解释一下通过横坐标x来得出y的计算过程：
         
         y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
         
         第一个self.maxAmplitude表示曲线的波峰值，360.0 / _waveWidth计算出单位间距1pixel代表的度数，x * M_PI / 180表示将横坐标值转换为角度。self.frequency表示角速度，即单位面积内波动次数，波浪的大小。self.phase * M_PI/ 180代表上面公式中的初相，通过规律的变化初相，可以制造出曲线上的点动起来的效果，self.maxAmplitude代表偏距，由于我们需要让波浪曲线的波峰在layer的范围内显示，所以需要将整个曲线向下移动波峰大小的单位，因为CALayer使用左手坐标系，所以向下移动需要加上波峰的大小。
         */
        CGFloat y = self.maxAmplitude * cosf(360.0 / _waveWidth * (x  * M_PI / 180.0) * self.frequency + self.phaseCos * M_PI / 180.0) + self.maxAmplitude;
        
        if (x == 0) {
            
            [wavePath moveToPoint:CGPointMake(x, y)];
            
        } else {
            
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(_sinView.bounds) + 10;
    
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    return wavePath;
}

@end
