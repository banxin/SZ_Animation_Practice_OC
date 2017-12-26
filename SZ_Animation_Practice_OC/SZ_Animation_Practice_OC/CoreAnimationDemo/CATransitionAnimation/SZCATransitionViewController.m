//
//  SZCATransitionViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZCATransitionViewController.h"

/*
 CATransition转场动画
 
 //转场类型,字符串类型参数.系统提供了四中动画形式:
 //kCATransitionFade//逐渐消失
 //kCATransitionMoveIn//移进来
 //kCATransitionPush//推进来
 //kCATransitionReveal//揭开
 //另外,除了系统给的这几种动画效果,我们还可以使用系统私有的动画效果:
 //@"cube",//立方体翻转效果
 //@"oglFlip",//翻转效果
 //@"suckEffect",//收缩效果,动画方向不可控
 //@"rippleEffect",//水滴波纹效果,动画方向不可控
 //@"pageCurl",//向上翻页效果
 //@"pageUnCurl",//向下翻页效果
 //@"cameralIrisHollowOpen",//摄像头打开效果,动画方向不可控
 //@"cameraIrisHollowClose",//摄像头关闭效果,动画方向不可控
 @property(copy) NSString *type;
 //转场方向,系统一共提供四个方向:
 //kCATransitionFromRight//从右开始
 //kCATransitionFromLeft//从左开始
 //kCATransitionFromTop//从上开始
 //kCATransitionFromBottom//从下开始
 @property(nullable, copy) NSString *subtype;
 //开始进度,默认0.0.如果设置0.3,那么动画将从动画的0.3的部分开始
 @property float startProgress;
 //结束进度,默认1.0.如果设置0.6,那么动画将从动画的0.6部分以后就会结束
 @property float endProgress;
 //开始进度
 @property(nullable, strong) id filter;
 
 CATransition也是继承CAAnimation,系统默认提供了12种动画样式,加上4个动画方向,除了方向不可控的四种效果外,大概一共提供了36种动画.
 
 另外系统还给UIView添加了很多分类方法可以快速完成一些简单的动画,如下:
 
 UIView(UIViewAnimation)
 
 @interface UIView(UIViewAnimation)
 
 + (void)beginAnimations:(nullable NSString *)animationID context:(nullable void *)context;  // additional context info passed to will start/did stop selectors. begin/commit can be nested
 //提交动画
 + (void)commitAnimations;
 //设置代理
 + (void)setAnimationDelegate:(nullable id)delegate;                          //设置动画开始方法
 + (void)setAnimationWillStartSelector:(nullable SEL)selector;
 //设置动画结束方法
 + (void)setAnimationDidStopSelector:(nullable SEL)selector;
 //设置动画时间:default = 0.2
 + (void)setAnimationDuration:(NSTimeInterval)duration;
 //设置动画延迟开始时间:default = 0.0
 + (void)setAnimationDelay:(NSTimeInterval)delay;
 //设置动画延迟开始日期:default = now ([NSDate date])
 + (void)setAnimationStartDate:(NSDate *)startDate;
 //设置动画运动曲线:default =UIViewAnimationCurveEaseInOut
 //UIViewAnimationCurveEaseInOut,//慢进慢出
 //UIViewAnimationCurveEaseIn, //慢进快出
 //UIViewAnimationCurveEaseOut,//快进慢出
 //UIViewAnimationCurveLinear//匀速
 + (void)setAnimationCurve:(UIViewAnimationCurve)curve;
 //设置重复次数: default = 0.0.  May be fractional
 + (void)setAnimationRepeatCount:(float)repeatCount;
 //设置是否翻转动画: default = NO. used if repeat
 + (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;
 //设置动画是否从当前状态开始:default = NO
 + (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState;
 //设置动画类型
 + (void)setAnimationTransition:(UIViewAnimationTransition)transition forView:(UIView *)view cache:(BOOL)cache;
 //设置动画是否有效
 + (void)setAnimationsEnabled:(BOOL)enabled;
 //
 + (BOOL)areAnimationsEnabled;
 //
 + (void)performWithoutAnimation:(void (^)(void))actionsWithoutAnimation
 //
 + (NSTimeInterval)inheritedAnimationDuration
 @end
 
 UIView(UIViewAnimationWithBlocks)
 
 
 @interface UIView(UIViewAnimationWithBlocks)
 //以下方法都大同小异,就不一一做注释了
 + (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
 + (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion
 + (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;
 + (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion
 + (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
 + (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^ __nullable)(BOOL finished))completion;
 + (void)performSystemAnimation:(UISystemAnimation)animation onViews:(NSArray<__kindof UIView *> *)views options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))parallelAnimations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
 
 @end
 
 UIView (UIViewKeyframeAnimations)
 
 + (void)animateKeyframesWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewKeyframeAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
 + (void)addKeyframeWithRelativeStartTime:(double)frameStartTime relativeDuration:(double)frameDuration animations:(void (^)(void))animations
 以上方法比较多,找值得说的简单说一下吧:
 
 //单视图转场动画
 + (void)transitionWithView:(UIView *)view
 duration:(NSTimeInterval)duration
 options:(UIViewAnimationOptions)options
 animations:(void (^ __nullable)(void))animations
 completion:(void (^ __nullable)(BOOL finished))completion
 //双视图转场动画
 + (void)transitionFromView:(UIView *)fromView
 toView:(UIView *)toView
 duration:(NSTimeInterval)duration
 options:(UIViewAnimationOptions)options
 completion:(void (^ __nullable)(BOOL finished))completion
 这两个都是转场动画,不同的是第一个是单视图转场,第二个是双视图转场.不过需要注意的是:单视图转场动画只能用作属性动画做不到的转场效果,比如属性动画不能给UIImageview的image赋值操作做动画效果等.
 
 我们可以看到以上两个方法中都有一个共同的参数:
 UIViewAnimationOptions
 
 typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
 UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
 UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
 UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
 UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
 UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
 UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
 UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
 UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
 UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
 UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
 
 UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
 UIViewAnimationOptionCurveEaseIn               = 1 << 16,
 UIViewAnimationOptionCurveEaseOut              = 2 << 16,
 UIViewAnimationOptionCurveLinear               = 3 << 16,
 
 UIViewAnimationOptionTransitionNone            = 0 << 20, // default
 UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
 UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
 UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
 UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
 UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
 UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
 UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
 } NS_ENUM_AVAILABLE_IOS(4_0);
 可以看到系统给到的是一个位移枚举,这就意味着这个枚举可以多个值同时使用,但是怎么用呢?其实那些枚举值可以分为三个部分.
 我们分别看一下每个枚举的意思:
 第一部分:动画效果
 
 UIViewAnimationOptionTransitionNone//没有效果
 UIViewAnimationOptionTransitionFlipFromLeft//从左水平翻转
 UIViewAnimationOptionTransitionFlipFromRight//从右水平翻转
 UIViewAnimationOptionTransitionCurlUp//翻书上掀
 UIViewAnimationOptionTransitionCurlDown//翻书下盖UIViewAnimationOptionTransitionCrossDissolve//融合
 UIViewAnimationOptionTransitionFlipFromTop//从上垂直翻转                    UIViewAnimationOptionTransitionFlipFromBottom//从下垂直翻转
 第二部分:动画运动曲线
 
 //开始慢，加速到中间，然后减慢到结束
 UIViewAnimationOptionCurveEaseInOut
 //开始慢，加速到结束
 UIViewAnimationOptionCurveEaseIn
 //开始快，减速到结束
 UIViewAnimationOptionCurveEaseOut
 //线性运动
 UIViewAnimationOptionCurveLinear
 第三部分:其他
 
 //默认，跟父类作为一个整体
 UIViewAnimationOptionLayoutSubviews
 //设置了这个，主线程可以接收点击事件
 UIViewAnimationOptionAllowUserInteraction
 //从当前状态开始动画，父层动画运动期间，开始子层动画.
 UIViewAnimationOptionBeginFromCurrentState
 //重复执行动画，从开始到结束， 结束后直接跳到开始态
 UIViewAnimationOptionRepeat
 //反向执行动画，结束后会再从结束态->开始态
 UIViewAnimationOptionAutoreverse
 //忽略继承自父层持续时间，使用自己持续时间（如果存在）
 UIViewAnimationOptionOverrideInheritedDuration
 //忽略继承自父层的线性效果，使用自己的线性效果（如果存在）
 UIViewAnimationOptionOverrideInheritedCurve
 //允许同一个view的多个动画同时进行
 UIViewAnimationOptionAllowAnimatedContent
 //视图切换时直接隐藏旧视图、显示新视图，而不是将旧视图从父视图移除（仅仅适用于转场动画）             UIViewAnimationOptionShowHideTransitionViews
 //不继承父动画设置或动画类型.
 UIViewAnimationOptionOverrideInheritedOptions
 这下可以看到,这些枚举功能都不一样但是可以随意组合,但是组合的时候需要注意,同一类型的枚举不能一起使用比如UIViewAnimationOptionCurveEaseIn和UIViewAnimationOptionCurveEaseOut
 
 */

@interface SZCATransitionViewController ()

@property (nonatomic, strong) UIImageView *demoView1;
@property (nonatomic, strong) UIImageView *demoView2;

@end

@implementation SZCATransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.demoView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _demoView1.center = CGPointMake(self.view.center.x + 120, self.view.center.y - 120);
    _demoView1.image = [UIImage imageNamed:@"lufei"];
    
    [self.view addSubview:_demoView1];
    
    self.demoView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _demoView2.center = CGPointMake(self.view.center.x + 120, self.view.center.y + 120);
    _demoView2.image = [UIImage imageNamed:@"lufei"];
    
    [self.view addSubview:_demoView2];
    
    NSArray *titles = @[@"单视图转场", @"双视图转场", @"CATransition转场"];
    
    for (unsigned int i = 0; i < titles.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 64 + 80 * i, 100, 60)];
        
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

- (void)animationBegin:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:[self animationSingleView:YES]; break;
        case 1:[self animationSingleView:NO]; break;
        case 2:[self chang3]; break;
        default:break;
    }
}

/**
 *  转场动画在执行过程中不可以被停止，
 *  转场动画在执行过程中不可以用户交互
 *  转场动画在执行过程中不可以控制动画执行进度
 */
/**
 *  基于UIView的单视图转场动画
 */

static NSUInteger change1_0Index = 0;
static NSUInteger change1_1Index = 0;
static NSUInteger change1_2Index = 0;

-(void)animationSingleView:(BOOL)sigle
{
    
    
    /**
     *  第一部分
     */
    NSArray *array0 = @[
                        @(UIViewAnimationOptionTransitionNone),
                        @(UIViewAnimationOptionTransitionFlipFromLeft),//从左水平翻转
                        @(UIViewAnimationOptionTransitionFlipFromRight),//从右水平翻转
                        @(UIViewAnimationOptionTransitionCurlUp),//翻书上掀
                        @(UIViewAnimationOptionTransitionCurlDown),//翻书下盖
                        @(UIViewAnimationOptionTransitionCrossDissolve),//融合
                        @(UIViewAnimationOptionTransitionFlipFromTop),//从上垂直翻转
                        @(UIViewAnimationOptionTransitionFlipFromBottom),//从下垂直翻转
                        ];
    
    /**
     *  第二部分
     */
    NSArray *array1 = @[
                        @(UIViewAnimationOptionCurveEaseInOut),////开始慢，加速到中间，然后减慢到结束
                        @(UIViewAnimationOptionCurveEaseIn),//开始慢，加速到结束
                        @(UIViewAnimationOptionCurveEaseOut),//开始快，减速到结束
                        @(UIViewAnimationOptionCurveLinear),//线性运动
                        ];
    
    /**
     *  第三部分
     */
    NSArray *array2 = @[
                        @(UIViewAnimationOptionLayoutSubviews),//默认，跟父类作为一个整体
                        @(UIViewAnimationOptionAllowUserInteraction),//设置了这个，主线程可以接收点击事件
                        @(UIViewAnimationOptionBeginFromCurrentState),//从当前状态开始动画，父层动画运动期间，开始子层动画。
                        @(UIViewAnimationOptionRepeat),//重复执行动画，从开始到结束， 结束后直接跳到开始态
                        @(UIViewAnimationOptionAutoreverse),//反向执行动画，结束后会再从结束态->开始态
                        @(UIViewAnimationOptionOverrideInheritedDuration),//忽略继承自父层持续时间，使用自己持续时间（如果存在）
                        @(UIViewAnimationOptionOverrideInheritedCurve),//忽略继承自父层的线性效果，使用自己的线性效果（如果存在）
                        @(UIViewAnimationOptionAllowAnimatedContent),//允许同一个view的多个动画同时进行
                        @(UIViewAnimationOptionShowHideTransitionViews),//视图切换时直接隐藏旧视图、显示新视图，而不是将旧视图从父视图移除（仅仅适用于转场动画）
                        @(UIViewAnimationOptionOverrideInheritedOptions),//不继承父动画设置或动画类型。
                        ];
    
    //    CASpringAnimation
    //    CASpringAnimation
    
    
    if (sigle) {
        
        [UIView transitionWithView:self.demoView1
                          duration:1
                           options:
         ((NSNumber *)array0[change1_0Index]).integerValue|
         ((NSNumber *)array1[change1_1Index]).integerValue|
         ((NSNumber *)array2[change1_2Index]).integerValue
                        animations:^{
                            
                            
                            
                            /**
                             *  单视图的转场动画需要在动画块中设置视图转场前的内容和视图转场后的内容
                             */
                            if (self.demoView1.tag == 0) {
                                self.demoView1.image = [UIImage imageNamed:@"transition_icon"];
                                self.demoView1.tag = 1;
                            }else{
                                self.demoView1.image = [UIImage imageNamed:@"lufei"];
                                self.demoView1.tag = 0;
                            }
                            
                            
                            
                            
                        } completion:nil];
        NSLog(@"动画:%s:%@:%@:%@",__func__,@(change1_0Index),@(change1_1Index),@(change1_2Index));
        
        
    }else{
        
        /**
         *  双视图的转场动画
         *  注意：双视图的转场动画实际上是操作视图移除和添加到父视图的一个过程，from视图必须要有父视图，to视图必须不能有父视图，否则会出问题
         *  比如动画不准等
         */
        
        UIImageView *fromView = nil;
        UIImageView *toView = nil;
        
        if (self.demoView1.tag == 0) {
            fromView = self.demoView1;
            toView = self.demoView2;
            self.demoView1.tag = 1;
        }else{
            fromView = self.demoView2;
            toView = self.demoView1;
            self.demoView1.tag = 0;
        }
        
        [UIView transitionFromView:fromView
                            toView:toView duration:1.0
                           options:
         ((NSNumber *)array0[change1_0Index]).integerValue|
         ((NSNumber *)array1[change1_1Index]).integerValue|
         ((NSNumber *)array2[change1_2Index]).integerValue
                        completion:^(BOOL finished) {
                            
                        }];
        
        
    }
    change1_0Index += 1;
    if (change1_0Index > array0.count - 1) {
        change1_0Index = 0;
        change1_1Index += 1;
    }
    if (change1_1Index > array1.count - 1) {
        change1_1Index = 0;
        change1_2Index += 1;
    }
    if (change1_2Index > array2.count - 1) {
        change1_2Index = 0;
        
        change1_0Index = 0;
        change1_2Index = 0;
        
    }
}



/**
 *  基于CATransition的视图转场动画
 */
static NSUInteger change3_0Index = 0;
static NSUInteger change3_1Index = 0;
-(void)chang3{
    
    /**
     *创建转场动画：注意：CATransaction和CATransition 不一样
     */
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.25;
    
    NSArray *type_array = @[
                            //系统提供的动画
                            kCATransitionFade,
                            kCATransitionMoveIn,
                            kCATransitionPush,
                            kCATransitionReveal,
                            
                            //以下是私有api,只能字符串访问
                            @"cube",//立方体翻转效果
                            @"oglFlip",//翻转效果
                            @"suckEffect",//收缩效果,动画方向不可控
                            @"rippleEffect",//水滴波纹效果,动画方向不可控
                            @"pageCurl",//向上翻页效果
                            @"pageUnCurl",//向下翻页效果
                            @"cameralIrisHollowOpen",//摄像头打开效果,动画方向不可控
                            @"cameraIrisHollowClose",//摄像头关闭效果,动画方向不可控
                            ];
    //转场类型
    transition.type = type_array[change3_0Index];
    
    NSArray *subtype_array = @[
                               kCATransitionFromRight,
                               kCATransitionFromLeft,
                               kCATransitionFromTop,
                               kCATransitionFromBottom
                               ];
    //转场方向
    transition.subtype = subtype_array[change3_1Index];
    
    /**
     *  设置转场动画的开始和结束百分比
     */
    transition.startProgress = 0.0;
    transition.endProgress = 1.0;
    
    
    if (self.demoView1.tag == 0) {
        self.demoView1.tag = 1;
        
        
        self.demoView1.image = [UIImage imageNamed:@"transition_icon"];
        self.demoView2.image = [UIImage imageNamed:@"transition_icon"];
    }else{
        self.demoView1.tag = 0;
        
        self.demoView1.image = [UIImage imageNamed:@"lufei"];
        self.demoView2.image = [UIImage imageNamed:@"lufei"];
    }
    [self.demoView1.layer addAnimation:transition forKey:nil];
    [self.demoView2.layer addAnimation:transition forKey:nil];
    
    NSLog(@"动画:%s:%@:%@",__func__,@(change3_0Index),@(change3_1Index));
    
    change3_1Index += 1;
    if (change3_1Index > subtype_array.count - 1) {
        change3_1Index = 0;
        change3_0Index += 1;
    }
    if (change3_0Index > type_array.count - 1) {
        change3_0Index = 0;
    }
    
}

@end






















