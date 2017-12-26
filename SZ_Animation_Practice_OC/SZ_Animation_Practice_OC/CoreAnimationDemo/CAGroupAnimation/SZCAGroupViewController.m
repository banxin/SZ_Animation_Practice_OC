//
//  SZCAGroupViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZCAGroupViewController.h"

/*
 CAAnimationGroup动画组
 
 CAAnimationGroup的属性
 
 //只有一个属性,数组中接受CAAnimation元素
 @property(nullable, copy) NSArray<CAAnimation *> *animations;
 可以看到CAAnimationGroup只有一个属性一个CAAnimation数组.而且它继承于CAAnimation,它具有CAAnimation的特性,所以它的用法和CAAnimation是一样的,不同的是他可以包含n个动画,也就是说他可以接受很多个CAAnimation并且可以让它们一起开始,这就造成了动画效果的叠加,效果就是n个动画同时进行.
 */

@interface SZCAGroupViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *demoView;

@end

@implementation SZCAGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.demoView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _demoView.center = CGPointMake(self.view.center.x + 120, self.view.center.y - 120);
    _demoView.text = @"DEMO";
    _demoView.textColor = [UIColor whiteColor];
    _demoView.textAlignment = NSTextAlignmentCenter;
    _demoView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_demoView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 64 + 20, 100, 60)];
    
    btn.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
    [btn setTitle:@"组动画" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)animationBegin:(UIButton *)btn
{
    [self groupAnimation:nil];
}

- (void)groupAnimation:(NSSet<UITouch *> *)touches
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    /**
     *  移动动画
     */
    CAKeyframeAnimation *position = [self moveAnimation:touches];
    /**
     *  摇晃动画
     */
    CAKeyframeAnimation *shake = [self shakeAnimation:touches];
    /**
     *  透明度动画
     */
    CABasicAnimation *alpha = [self alphaAnimation:touches];
    
    /**
     *  设置动画组的时间,这个时间表示动画组的总时间，它的子动画的时间和这个时间没有关系
     */
    [group setDuration:3.0];
    [group setAnimations:@[position,shake,alpha]];
    
    
    [self.demoView.layer addAnimation:group forKey:nil];
}

#pragma mark -- CAKeyframeAnimation - 路径平移动画
- (CAKeyframeAnimation *)moveAnimation:(NSSet<UITouch *> *)touches
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    /**
     *  设置路径，按圆运动
     */
    
    UIBezierPath *bPah = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 320)];
    animation.path = bPah.CGPath;
    
//    CGMutablePathRef path = CGPathCreateMutable();//CG是C语言的框架，需要直接写语法
//    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 320, 320));
//    [animation setPath:path];//把路径给动画
//    CGPathRelease(path);//释放路径
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:3];
    
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    return animation;
}

#pragma mark -- CAKeyframeAnimation - 摇晃动画
-(CAKeyframeAnimation *)shakeAnimation:(NSSet<UITouch *> *)touches{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    /**
     *  设置路径，贝塞尔路径
     */
    CGFloat angle = M_PI_4 * 0.1;
    NSArray *values = @[@(angle),@(-angle),@(angle)];
    [animation setValues:values];
    [animation setRepeatCount:10];
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:0.25];
    return animation;
}

#pragma mark -- CABasicAnimation - 淡如淡出动画
-(CABasicAnimation *)alphaAnimation:(NSSet<UITouch *> *)touches{
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    [animation setDuration:1.0];
    /**
     * 设置重复次数
     */
    [animation setRepeatCount:3];
    /**
     * 设置自动翻转
     * 设置自动翻转以后单次动画时间不变，总动画时间延迟一倍，它会让你前半部分的动画以相反的方式动画过来
     * 比如说你设置执行一次动画，从a到b时间为1秒，设置自动翻转以后动画的执行方式为，先从a到b执行一秒，然后从b到a再执行一下动画结束
     */
    [animation setAutoreverses:YES];
    /**
     * 设置起始值
     */
    [animation setFromValue:@1.0];
    
    [animation setDelegate:self];
    
    /**
     * 设置目标值
     */
    [animation setToValue:@0.1];
    /**
     * 将动画添加到layer 添加到图层开始执行动画，
     * 注意：key值的设置与否会影响动画的效果
     * 如果不设置key值每次执行都会创建一个动画，然后创建的动画会叠加在图层上
     * 如果设置key值，系统执行这个动画时会先检查这个动画有没有被创建，如果没有的话就创建一个，如果有的话就重新从头开始执行这个动画
     * 你可以通过key值获取或者删除一个动画
     */
    return animation;
}

/**
 *  动画开始和动画结束时 self.demoView.center 是一直不变的，说明动画并没有改变视图本身的位置
 */
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画开始------：%@",    NSStringFromCGPoint(self.demoView.center));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画结束------：%@",    NSStringFromCGPoint(self.demoView.center));
}

@end





















