//
//  SZKeyFrameAnimationViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZKeyFrameAnimationViewController.h"

/*
 CAKeyframeAnimation的属性
 
 //关键帧值数组,一组变化值
 @property(nullable, copy) NSArray *values;
 //关键帧帧路径,优先级比values大
 @property(nullable) CGPathRef path;
 //每一帧对应的时间,时间可以控制速度.它和每一个帧相对应,取值为0.0-1.0,不设则每一帧时间相等.
 @property(nullable, copy) NSArray<NSNumber *> *keyTimes;
 //每一帧对应的时间曲线函数,也就是每一帧的运动节奏
 @property(nullable, copy) NSArray<CAMediaTimingFunction *> *timingFunctions;
 //动画的计算模式,默认值: kCAAnimationLinear.有以下几个值:
 //kCAAnimationLinear//关键帧为座标点的时候,关键帧之间直接直线相连进行插值计算;
 //kCAAnimationDiscrete//离散的,也就是没有补间动画
 //kCAAnimationPaced//平均，keyTimes跟timeFunctions失效
 //kCAAnimationCubic对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算,对于曲线的形状还可以通过tensionValues,continuityValues,biasValues来进行调整自定义,keyTimes跟timeFunctions失效
 //kCAAnimationCubicPaced在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,,keyTimes跟timeFunctions失效
 @property(copy) NSString *calculationMode;
 //动画的张力,当动画为立方计算模式的时候此属性提供了控制插值,因为每个关键帧都可能有张力所以连续性会有所偏差它的范围为[-1,1].同样是此作用
 @property(nullable, copy) NSArray<NSNumber *> *tensionValues;
 //动画的连续性值
 @property(nullable, copy) NSArray<NSNumber *> *continuityValues;
 //动画的偏斜率
 @property(nullable, copy) NSArray<NSNumber *> *biasValues;
 //动画沿路径旋转方式,默认为nil.它有两个值:
 //kCAAnimationRotateAuto//自动旋转,
 //kCAAnimationRotateAutoReverse//自动翻转
 @property(nullable, copy) NSString *rotationMode;

 */

@interface SZKeyFrameAnimationViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *demoView;

@end

@implementation SZKeyFrameAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.demoView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _demoView.center = CGPointMake(self.view.center.x, 10 + 64 + 50);
    _demoView.text = @"DEMO";
    _demoView.textColor = [UIColor whiteColor];
    _demoView.textAlignment = NSTextAlignmentCenter;
    _demoView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_demoView];
    
    NSArray *titles = @[
                        @"path椭圆",
                        @"贝塞尔矩形",
                        @"贝塞尔抛物线",
                        @"贝塞尔s曲线",
                        @"贝塞尔圆",
                        @"弹力仿真",
                        @"自晃动",
                        @"指定点平移",
                        ];
    
    for (unsigned int i = 0; i < titles.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 64 + 35 * i, 100, 30)];
        
        btn.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

- (void)animationBegin:(UIButton *)bt
{
    switch (bt.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            [self path:bt.tag];break;
        case 6:
        case 7:
            [self values:bt.tag];break;
            
        default:
            break;
    }
    
}

- (void)path:(NSInteger)tag
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    switch (tag) {
        case 0:{
            
            // 椭圆
            UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 500)];
            
            animation.path = bPath.CGPath;
            
//            //椭圆
//            CGMutablePathRef path = CGPathCreateMutable();//创建可变路径
//            CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 320, 500));
//            [animation setPath:path];
//            CGPathRelease(path);
            animation.rotationMode = kCAAnimationRotateAuto;
            
        }break;
        case 1:{
            //贝塞尔,矩形
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
            //animation需要的类型是CGPathRef，UIBezierPath是ui的,需要转化成CGPathRef
            [animation setPath:path.CGPath];
            
            
        }break;
        case 2:{
            //贝塞尔,抛物线
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:self.demoView.center];
            [path addQuadCurveToPoint:CGPointMake(0, 568)
                         controlPoint:CGPointMake(400, 100)];
            [animation setPath:path.CGPath];
            
        }break;
        case 3:{
            //贝塞尔,s形曲线
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointZero];
            [path addCurveToPoint:self.demoView.center
                    controlPoint1:CGPointMake(320, 100)
                    controlPoint2:CGPointMake(  0, 400)];
            ;
            [animation setPath:path.CGPath];
            
            
        }break;
        case 4:{
            //贝塞尔,圆形
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center
                                                                radius:150
                                                            startAngle:- M_PI * 0.5
                                                              endAngle:M_PI * 2
                                                             clockwise:YES];
            [animation setPath:path.CGPath];
            
            
        }break;
        case 5:{
            
            // 弹力仿真可以使用 UIDynamic 框架实现！！！
            
            CGPoint point = CGPointMake(self.view.center.x, 400);
            CGFloat xlength = point.x - self.demoView.center.x;
            CGFloat ylength = point.y - self.demoView.center.y;
            
            CGMutablePathRef path = CGPathCreateMutable();
            //移动到目标点
            CGPathMoveToPoint(path, NULL, self.demoView.center.x, self.demoView.center.y);
            //将目标点的坐标添加到路径中
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
            //设置弹力因子,
            CGFloat offsetDivider = 5.0f;
            BOOL stopBounciong = NO;
            while (stopBounciong == NO) {
                CGPathAddLineToPoint(path, NULL, point.x + xlength / offsetDivider, point.y + ylength / offsetDivider);
                CGPathAddLineToPoint(path, NULL, point.x, point.y);
                offsetDivider += 6.0;
                //当视图的当前位置距离目标点足够小我们就退出循环
                if ((ABS(xlength / offsetDivider) < 10.0f) && (ABS(ylength / offsetDivider) < 10.0f)) {
                    break;
                }
            }
            [animation setPath:path];
            
        }break;
        default:break;
    }
    
    [animation setDuration:0.5];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:nil];
}


-(void)values:(NSInteger)tag{
    
    CAKeyframeAnimation *animation = nil;
    switch (tag) {
        case 6:{
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            
            CGFloat angle = M_PI_4 * 0.5;
            NSArray *values = @[@(angle),@(-angle),@(angle)];
            [animation setValues:values];
            [animation setRepeatCount:3];
            [animation setDuration:0.5];
        }break;
        case 7:{
            
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue *p1 = [NSValue valueWithCGPoint:self.demoView.center];
            NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x + 100, 200)];
            NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, 300)];
            //设置关键帧的值
            [animation setValues:@[p1,p2,p3]];
            [animation setDuration:0.5];
        }break;
        default:break;
    }
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:nil];
}


- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animation-start ======start:%@",NSStringFromCGRect(self.demoView.frame));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animation-start ======end:%@",NSStringFromCGRect(self.demoView.frame));
}


@end
















