//
//  SZBasicAnimationViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZBasicAnimationViewController.h"

/*
 CABasicAnimation基本动画
 
 CABasicAnimation的属性
 
 //开始值
 @property(nullable, strong) id fromValue;
 //结束值
 @property(nullable, strong) id toValue;
 //结束值
 @property(nullable, strong) id byValue;
 
 这三个属性之间的规则
 
 fromValue和toValue不为空,动画的效果会从fromValue的值变化到toValue.
 fromValue和byValue都不为空,动画的效果将会从fromValue变化到fromValue+byValue
 toValue和byValue都不为空,动画的效果将会从toValue-byValue变化到toValue
 只有fromValue的值不为空,动画的效果将会从fromValue的值变化到当前的状态.
 只有toValue的值不为空,动画的效果将会从当前状态的值变化到toValue的值.
 只有byValue的值不为空,动画的效果将会从当前的值变化到(当前状态的值+byValue)的值.
 
 */

@interface SZBasicAnimationViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *demoView;

@end

@implementation SZBasicAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.demoView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _demoView.center = self.view.center;
    _demoView.text = @"DEMO";
    _demoView.textColor = [UIColor whiteColor];
    _demoView.textAlignment = NSTextAlignmentCenter;
    _demoView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_demoView];
    
    NSArray *titles = @[@"淡入淡出", @"缩放", @"旋转", @"平移"];
    
    for (unsigned int i = 0; i < titles.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 64 + 80 * i, 100, 60)];
        
        btn.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

- (void)animationBegin:(UIButton *)btn
{
    CABasicAnimation *animation = nil;
    switch (btn.tag) {
        case 0:{
            //淡如淡出
            animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation setFromValue:@1.0];
            [animation setToValue:@0.1];
        }break;
        case 1:{
            //缩放
            animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            [animation setFromValue:@1.0];//设置起始值
            [animation setToValue:@0.1];//设置目标值
        }break;
        case 2:{
            //旋转
            animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            //setFromValue不设置,默认以当前状态为准
            [animation setToValue:@(M_PI)];
        }break;
        case 3:{
            //平移
            animation = [CABasicAnimation animationWithKeyPath:@"position"];
            //setFromValue不设置,默认以当前状态为准
            [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y + 200)]];
        }break;
        default:break;
    }
    [animation setDelegate:self];//代理回调
    [animation setDuration:0.25];//设置动画时间，单次动画时间
    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    /**
     *设置时间函数CAMediaTimingFunction
     *kCAMediaTimingFunctionLinear 匀速
     *kCAMediaTimingFunctionEaseIn 开始速度慢，后来速度快
     *kCAMediaTimingFunctionEaseOut 开始速度快 后来速度慢
     *kCAMediaTimingFunctionEaseInEaseOut = kCAMediaTimingFunctionDefault 中间速度快，两头速度慢
     */
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //设置自动翻转
    //设置自动翻转以后单次动画时间不变，总动画时间增加一倍，它会让你前半部分的动画以相反的方式动画过来
    //比如说你设置执行一次动画，从a到b时间为1秒，设置自动翻转以后动画的执行方式为，先从a到b执行一秒，然后从b到a再执行一下动画结束
    [animation setAutoreverses:YES];
    //kCAFillModeForwards//动画结束后回到准备状态
    //kCAFillModeBackwards//动画结束后保持最后状态
    //kCAFillModeBoth//动画结束后回到准备状态,并保持最后状态
    //kCAFillModeRemoved//执行完成移除动画
    [animation setFillMode:kCAFillModeBoth];
    //将动画添加到layer,添加到图层开始执行动画，
    //注意:key值的设置与否会影响动画的效果
    //如果不设置key值每次执行都会创建一个动画，然后创建的动画会叠加在图层上
    //如果设置key值，系统执行这个动画时会先检查这个动画有没有被创建，如果没有的话就创建一个，如果有的话就重新从头开始执行这个动画
    //你可以通过key值获取或者删除一个动画:
    //[self.demoView.layer animationForKey:@""];
    //[self.demoView.layer removeAnimationForKey:@""]
    [self.demoView.layer addAnimation:animation forKey:@"baseanimation"];
}

/**
 *  动画开始和动画结束时 self.demoView.center 是一直不变的，说明动画并没有改变视图本身的位置
 */
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"动画开始------：%@",    NSStringFromCGPoint(self.demoView.center));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束------：%@",    NSStringFromCGPoint(self.demoView.center));
}

@end
