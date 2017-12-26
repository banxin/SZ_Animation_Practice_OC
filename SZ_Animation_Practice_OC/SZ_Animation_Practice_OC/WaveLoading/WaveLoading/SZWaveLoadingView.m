//
//  SZWaveLoadingView.m
//  WaveDemo
//
//  Created by yanl on 2017/11/24.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZWaveLoadingView.h"

static CGFloat const kWavePositionDuration = 5;

// 左右的单次偏移量
static CGFloat const kWavePhaseShift = 8;

typedef NS_ENUM(NSInteger, SZWavePathType) {
    
    // 正弦
    SZWavePathType_Sin,
    // 余弦
    SZWavePathType_Cos
};

/*
 参考文档
 
 http://www.cocoachina.com/ios/20161202/18252.html
 */

@interface SZWaveLoadingView ()

/*
 波浪相关的参数
 */
// 角速度，即单位面积内波动次数，决定波浪的大小
@property (nonatomic, assign) CGFloat frequency;

// 波浪的宽度
@property (nonatomic, assign) CGFloat waveWidth;

// 波浪的高度
@property (nonatomic, assign) CGFloat waveHeight;

// 振幅
@property (nonatomic, assign) CGFloat maxAmplitude;

// 左右偏移量
@property (nonatomic, assign) CGFloat phase;

/*
 view相关
 */

// 底部灰色视图
@property (nonatomic, strong) UIImageView *grayImageView;
// 第二层视图
@property (nonatomic, strong) UIImageView *sineImageView;
// 第三层视图
@property (nonatomic, strong) UIImageView *cosineImageView;

// 第二层正弦layer
@property (nonatomic, strong) CAShapeLayer *waveSinLayer;
// 第三层余弦layer
@property (nonatomic, strong) CAShapeLayer *waveCosLayer;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation SZWaveLoadingView

+ (instancetype)loadingView
{
    return [[SZWaveLoadingView alloc] initWithFrame:CGRectMake(0, 0, 31, 34)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupSubViews];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(31, 34);
}

#pragma mark - Public Methods
- (void)startLoading
{
    // 初始化 displayLink
    [_displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(updateWave:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
    
    // 获取 position
    CGPoint position = self.waveSinLayer.position;
    
    // 这个 - 10 ，是配合画曲线时的 +10，如果不移动，则动画在图片的 top 就消失了，为了效果更好添加的
    position.y = position.y - self.bounds.size.height - 10;
    
    // 创建 key 为 “position” 的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 开始位置
    animation.fromValue = [NSValue valueWithCGPoint:self.waveSinLayer.position];
    // 结束位置
    animation.toValue = [NSValue valueWithCGPoint:position];
    // 动画时长
    animation.duration = kWavePositionDuration;
    // 重复次数
    animation.repeatCount = HUGE_VALF;
    // 是否在完成后移除
    animation.removedOnCompletion = NO;
    // 是否执行逆动画
//    animation.autoreverses = YES;
    
    // 添加动画
    [self.waveSinLayer addAnimation:animation forKey:@"positionWave"];
    [self.waveCosLayer addAnimation:animation forKey:@"positionWave"];
}

- (void)stopLoading
{
    // 停止刷新
    [self.displayLink invalidate];
    // 移除动画和路径
    [self.waveSinLayer removeAllAnimations];
    [self.waveCosLayer removeAllAnimations];
    self.waveSinLayer.path = nil;
    self.waveCosLayer.path = nil;
}

#pragma mark - Private Methods

- (void)setupSubViews
{
    // 初始化中间层 波浪
    self.waveSinLayer = [CAShapeLayer layer];
    
    // 设置背景颜色必须需要 透明色，不然看到 波浪效果不明显，由于使用的是 mask 属性的缘故，当然最好是不设颜色
//    _waveSinLayer.backgroundColor = [UIColor greenColor].CGColor;
    // 填充颜色 无所谓，有没有都可以，要的只是形状
//    self.waveSinLayer.fillColor = [[UIColor greenColor] CGColor];
    self.waveSinLayer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    
    // 初始化最上层 波浪
    self.waveCosLayer = [CAShapeLayer layer];
    
//    _waveCosLayer.backgroundColor = [UIColor greenColor].CGColor;
//    self.waveCosLayer.fillColor = [[UIColor greenColor] CGColor];
    self.waveCosLayer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    
    // 波浪的高度
    self.waveHeight = CGRectGetHeight(self.bounds) * 0.5;
    // 波浪的宽度
    self.waveWidth  = CGRectGetWidth(self.bounds);
    // 曲线的左右伸缩
    self.frequency = .3;
    
    // 波峰的高度
    self.maxAmplitude = self.waveHeight * .3;
    
    // 以下为初始化三张图片
    _grayImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _grayImageView.image = [UIImage imageNamed:@"du.png"];
    
    [self addSubview:_grayImageView];
    
    _cosineImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _cosineImageView.image = [UIImage imageNamed:@"gray.png"];
    
    [self addSubview:_cosineImageView];
    
    _sineImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _sineImageView.image = [UIImage imageNamed:@"blue.png"];
    
    [self addSubview:_sineImageView];
    
    // 设置上面两张图片的蒙版图层
    /*
     这个属性本身也是CALayer类型，有和其他图层一样的绘制和布局属性。它类似于一个子视图，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子视图。不同于一般的subLayer，mask定义了父图层的可见区域，简单点说就是最终父视图显示的形态是父视图自身和它的属性mask的交集部分。
     
     mask图层的color属性是无关紧要的，真正重要的是它的轮廓，mask属性就像一个切割机，父视图被mask切割，相交的部分会留下，其他的部分则被丢弃。
     CALayer的蒙版图层真正厉害的地方在于蒙版图层不局限于静态图，任何有图层构成的都可以作为mask属性，这意味着蒙版可以通过代码甚至是动画实时生成。这也为我们实现示例中波浪的变化提供了支持。
     */
    _sineImageView.layer.mask = _waveSinLayer;
    _cosineImageView.layer.mask = _waveCosLayer;
}

- (void)updateWave:(CADisplayLink *)displayLink
{
    // 逐渐累加初相，更新初相的位置
    self.phase += kWavePhaseShift;
    // 重新绘制 路径
    self.waveSinLayer.path = [self createWavePathWithType:SZWavePathType_Sin].CGPath;
    self.waveCosLayer.path = [self createWavePathWithType:SZWavePathType_Cos].CGPath;
}

/**
 
 正弦曲线
 x值在(-2π , 2π )的范围类，在[-1, 1]之间变化。
 
 正弦曲线，它可以表示为y=Asin(ωx+φ)+k
 
 A–振幅，即波峰的高度，最高点到最低点的高度。
 (ωx+φ)–相位，反应了变量y所处的位置。
 φ–初相，x=0时的相位，反映在坐标系上则为图像的左右移动。
 k–偏距，反映在坐标系上则为图像的上移或下移。
 ω–角速度，控制正弦周期(单位角度内震动的次数，也就是坡度陡还是缓)。
 */
- (UIBezierPath *)createWavePathWithType:(SZWavePathType)pathType
{
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    
    CGFloat endX = 0;
    
    for (CGFloat x = 0; x < self.waveWidth + 1; x += 1) {
        
        endX = x;
        
        /*
         在这里我们设定了两个正弦曲线上的点的横坐标间距是1，现在来解释一下通过横坐标x来得出y的计算过程：
         
         y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
         
         第一个self.maxAmplitude表示曲线的波峰值，360.0 / _waveWidth计算出单位间距1pixel代表的度数，x * M_PI / 180表示将横坐标值转换为角度。self.frequency表示角速度，即单位面积内波动次数，波浪的大小。self.phase * M_PI/ 180代表上面公式中的初相，通过规律的变化初相，可以制造出曲线上的点动起来的效果，self.maxAmplitude代表偏距，由于我们需要让波浪曲线的波峰在layer的范围内显示，所以需要将整个曲线向下移动波峰大小的单位，因为CALayer使用左手坐标系，所以向下移动需要加上波峰的大小。
         */
        
        CGFloat y = 0;
        
        if (pathType == SZWavePathType_Sin) {
            
            // self.maxAmplitude 振幅
            // 360.0 / _waveWidth * (x  * M_PI / 180.0) * self.frequency  角速度，单位角度内震动的次数，值越大，峰越陡，反之，则缓
            // + self.phase * M_PI / 180.0 初相 左右移动
            // + self.maxAmplitude 偏距 上下移动
            y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
            
        } else {
            
            y = self.maxAmplitude * cosf(360.0 / _waveWidth * (x * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
        }
        
        if (x == 0) {
            
            [wavePath moveToPoint:CGPointMake(x, y)];
            
        } else {
            
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    // 这个 + 10 ，是配合做动画时的 -10，如果不移动，则动画在图片的 top 就消失了，为了效果更好添加的
    CGFloat endY = CGRectGetHeight(self.bounds) + 10;
    
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    return wavePath;
}

@end





























