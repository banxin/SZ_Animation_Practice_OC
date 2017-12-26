//
//  CoreAnimationListViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "CoreAnimationListViewController.h"
#import "SZBasicAnimationViewController.h"
#import "SZSpringAnimationViewController.h"

/*
 
 http://www.jianshu.com/p/d05d19f70bac
 
 2、核心动画类的层次结构
 
 CAAnimation{
     CAPropertyAnimation{
         CABasicAnimation{
                 CASpringAnimation
         }
         CAKeyframeAnimation
     }
     CATransition
     CAAnimationGroup
 }
 
 Core Animation classes and protocol.png
 
 　　CAAnimation是所有动画对象的父类，实现CAMediaTiming协议，负责控制动画的时间、速度和时间曲线等等，是一个抽象类，不能直接使用。
 　　CAPropertyAnimation ：是CAAnimation的子类，它支持动画地显示图层的keyPath，一般不直接使用。
 　　iOS9.0之后新增CASpringAnimation类，它实现弹簧效果的动画，是CABasicAnimation的子类。
 
 综上，核心动画类中可以直接使用的类有：
 
 CABasicAnimation
 　　CAKeyframeAnimation
 　　CATransition
 　　CAAnimationGroup
 　　CASpringAnimation
 
 ３、核心动画类的核心方法
 
 1.初始化CAAnimation对象
 　　一般使用animation方法生成实例
 
 + (instancetype)animation;
 如果是CAPropertyAnimation的子类，还可以通过animationWithKeyPath生成实例
 
 + (instancetype)animationWithKeyPath:(nullable NSString *)path;
 2.设置动画的相关属性
 　　设置动画的执行时间，执行曲线，keyPath的目标值，代理等等
 
 3.动画的添加和移除
 　　调用CALayer的addAnimation:forKey:方法将动画添加到CALayer中，这样动画就开始执行了
 
 - (void)addAnimation:(CAAnimation *)anim forKey:(nullable NSString *)key;
 调用CALayer的removeAnimation方法停止CALayer中的动画
 
 - (void)removeAnimationForKey:(NSString *)key;
 - (void)removeAllAnimations;
 ４、核心动画类的常用属性
 
 keyPath：可以指定keyPath为CALayer的属性值，并对它的值进行修改，以达到对应的动画效果，需要注意的是部分属性值是不支持动画效果的。
 　　以下是具有动画效果的keyPath：
 
 //CATransform3D Key Paths : (example)transform.rotation.z
 //rotation.x
 //rotation.y
 //rotation.z
 //rotation 旋轉
 //scale.x
 //scale.y
 //scale.z
 //scale 缩放
 //translation.x
 //translation.y
 //translation.z
 //translation 平移
 
 //CGPoint Key Paths : (example)position.x
 //x
 //y
 
 //CGRect Key Paths : (example)bounds.size.width
 //origin.x
 //origin.y
 //origin
 //size.width
 //size.height
 //size
 
 //opacity
 //backgroundColor
 //cornerRadius
 //borderWidth
 //contents
 
 //Shadow Key Path:
 //shadowColor
 //shadowOffset
 //shadowOpacity
 //shadowRadius
 duration：动画的持续时间
 　　repeatCount：动画的重复次数
 　　timingFunction：动画的时间节奏控制
 
 timingFunctionName的enum值如下：
 kCAMediaTimingFunctionLinear 匀速
 kCAMediaTimingFunctionEaseIn 慢进
 kCAMediaTimingFunctionEaseOut 慢出
 kCAMediaTimingFunctionEaseInEaseOut 慢进慢出
 kCAMediaTimingFunctionDefault 默认值（慢进慢出）
 fillMode：视图在非Active时的行为
 　　removedOnCompletion：动画执行完毕后是否从图层上移除，默认为YES（视图会恢复到动画前的状态），可设置为NO（图层保持动画执行后的状态，前提是fillMode设置为kCAFillModeForwards）
 　　beginTime：动画延迟执行时间（通过CACurrentMediaTime() + your time 设置）
 　　delegate：代理
 
 代理方法如下：
 - (void)animationDidStart:(CAAnimation *)anim;  //动画开始
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag; //动画结束
 
 
 CAAnimation-属性(复杂点的属性,下面会有详细解释)
 
 //动画的代理回调,下面会有
 @property(nullable, strong) id delegate;
 //动画执行完以后是否移除动画,默认YES
 @property(getter=isRemovedOnCompletion) BOOL removedOnCompletion;
 //动画的动作规则,包含以下值
 //kCAMediaTimingFunctionLinear 匀速
 //kCAMediaTimingFunctionEaseIn 慢进快出
 //kCAMediaTimingFunctionEaseOut 快进慢出
 //kCAMediaTimingFunctionEaseInEaseOut 慢进慢出 中间加速
 //kCAMediaTimingFunctionDefault 默认
 @property(nullable, strong) CAMediaTimingFunction *timingFunction;
 
 以上属性的详解:
 
 delegate:动画执行的代理,在动画开始前设定,不用显式的写在代码里,它包含两个方法:
 动画开始回调
 - (void)animationDidStart:(CAAnimation *)anim;
 动画结束回调
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
 removedOnCompletion:动画完成后是否移除动画.默认为YES.此属性为YES时, fillMode不可用,具体为什么不可用,可以自己结合两个属性分析一下,这里不再赘述.
 timingFunction 设置动画速度曲线,默认值上面已经给出.下面说它的几个方法:
 这两个方法是一样的.如果我们对系统自带的速度函数不满意,可以通过这两个函数创建一个自己喜欢的速度曲线函数,具体用法可以参考这篇文章CAMediaTimingFunction的使用
 + (instancetype)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
 - (instancetype)initWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
 获取曲线函数的缓冲点,具体用法可以参考这篇文章:iOS-核心动画高级编程/10-缓冲
 - (void)getControlPointAtIndex:(size_t)idx values:(float[2])ptr;
 
 CAAnimation <CAMediaTiming>协议的属性
 
 //开始时间.这个属性比较复杂,傻瓜用法为:CACurrentMediaTime() + x,
 //其中x为延迟时间.如果设置 beginTime = CACurrentMediaTime() + 1.0,产生的效果为延迟一秒执行动画,下面详解原理
 @property CFTimeInterval beginTime;
 //动画执行时间,此属性和speed有关系speed默认为1.0,如果speed设置为2.0,那么动画执行时间则为duration*(1.0/2.0).
 @property CFTimeInterval duration;
 //动画执行速度,它duration的关系参考上面解释
 @property float speed;
 //动画的时间延迟,这个属性比较复杂,下面详解
 @property CFTimeInterval timeOffset;
 //重复执行次数
 @property float repeatCount;
 //重复执行时间,此属性优先级大于repeatCount.也就是说如果repeatDuration设置为1秒重复10次,那么它会在1秒内执行完动画.
 @property CFTimeInterval repeatDuration;
 //是否自动翻转动画,默认NO.如果设置YES,那么整个动画的执行效果为A->B->A.
 @property BOOL autoreverses;
 //动画的填充方式,默认为: kCAFillModeRemoved,包含以下值
 //kCAFillModeForwards//动画结束后回到准备状态
 //kCAFillModeBackwards//动画结束后保持最后状态
 //kCAFillModeBoth//动画结束后回到准备状态,并保持最后状态
 //kCAFillModeRemoved//执行完成移除动画
 @property(copy) NSString *fillMode;
 
 以上属性的详解:
 
 beginTime:刚才上面简单解释了下这个属性的用法:CACurrentMediaTime()+ x 会使动画延迟执行x秒.不知道到这里有没有人想过如果-x会出现怎么样效果?假设我们有执行一个3秒的动画,然后设置beginTime = CACurrentMediaTime()- 1.5那么执行动画你会发现动画只会执行后半段,也就是只执行后面的3-1.5s的动画.为什么会这样?其实动画都有一个timeline(时间线)的概念.动画开始执行都是基于这个时间线的绝对时间,这个时间和它的父类有关(系统的属性注释可以看到).默认的CALayer的beginTime为零,如果这个值为零的话,系统会把它设置为CACurrentMediaTime(),那么这个时间就是正常执行动画的时间:立即执行.所以如果你设置beginTime=CACurrentMediaTime()+x;它会把它的执行时间线推迟x秒,也就是晚执行x秒,如果你beginTime=CACurrentMediaTime()-x;那它开始的时候会从你动画对应的绝对时间开始执行.
 timeOffset:时间偏移量,默认为0;既然它是时间偏移量,那么它即和动画时间相关.这么解释:假设我们设置一个动画时间为5s,动画执行的过程为1->2->3->4->5,这时候如果你设置timeOffset = 2s那么它的执行过程就会变成3->4->5->1->2如果你设置timeOffset = 4s那么它的执行过程就会变成5->1->2->3->4,这么说应该很明白了吧?
 
 CAPropertyAnimation属性动画,抽象类,不能直接使用
 
 CAPropertyAnimation的属性
 
 //需要动画的属性值
 @property(nullable, copy) NSString *keyPath;
 //属性动画是否以当前动画效果为基础,默认为NO
 @property(getter=isAdditive) BOOL additive;
 //指定动画是否为累加效果,默认为NO
 @property(getter=isCumulative) BOOL cumulative;
 //此属性相当于CALayer中的transform属性,下面会详解
 @property(nullable, strong) CAValueFunction *valueFunction;
 
 以上属性的详解:
 
 CAPropertyAnimation是属性动画.顾名思义也就是针对属性才可以做的动画.那它可以对谁的属性可以做动画?是CALayer的属性,比如:bounds,position等.那么问题来了,我们改变CALayer的position可以直接设置[CAPropertyAnimation animationWithKeyPath:@"position"]如果我们设置它的transform(CATransform3D)呢?CATransform3D是一个矩阵,如果我们想为它做动画怎么办?下面这个属性就是用来解决这个问题的.
 
 valueFunction:我们来看它可以设置的值:
 kCAValueFunctionRotateX
 kCAValueFunctionRotateY
 kCAValueFunctionRotateZ
 kCAValueFunctionScale
 kCAValueFunctionScaleX
 kCAValueFunctionScaleY
 kCAValueFunctionScaleZ
 kCAValueFunctionTranslate
 kCAValueFunctionTranslateX
 kCAValueFunctionTranslateY
 kCAValueFunctionTranslateZ
 说到这里大家应该都知道该怎么用了吧~.
 
 CAPropertyAnimation的方法
 
 //通过key创建一个CAPropertyAnimation对象
 + (instancetype)animationWithKeyPath:(nullable NSString *)path;
 下面我们来看一下可以设置属性动画的属性归总:
 
 CATransform3D{
 rotation旋转
 transform.rotation.x
 transform.rotation.y
 transform.rotation.z
 
 scale缩放
 transform.scale.x
 transform.scale.y
 transform.scale.z
 
 translation平移
 transform.translation.x
 transform.translation.y
 transform.translation.z
 }
 
 CGPoint{
 position
 position.x
 position.y
 }
 
 CGRect{
 bounds
 bounds.size
 bounds.size.width
 bounds.size.height
 
 bounds.origin
 bounds.origin.x
 bounds.origin.y
 }
 
 property{
 opacity
 backgroundColor
 cornerRadius
 borderWidth
 contents
 
 Shadow{
 shadowColor
 shadowOffset
 shadowOpacity
 shadowRadius
 }
 }
 总结: CAAnimation是基类, CAPropertyAnimation是抽象类,两者都不可以直接使用, 那我们只有使用它的子类了.
 
 
 */

@interface CoreAnimationListViewController ()

@property (nonatomic, strong) NSArray *functionList;
@property (nonatomic, strong) NSArray *functionListChinese;

@end

@implementation CoreAnimationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.functionList[indexPath.row];
    cell.detailTextLabel.text = self.functionListChinese[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.
    if (0 == indexPath.row) {
        
        [self push:@"SZBasicAnimationViewController"];
    }
    
    // 2.
    if (1 == indexPath.row) {
        
        [self push:@"SZSpringAnimationViewController"];
    }
    
    // 3.
    if (2 == indexPath.row) {
        
        [self push:@"SZKeyFrameAnimationViewController"];
    }
    
    // 4.
    if (3 == indexPath.row) {
        
        [self push:@"SZCAGroupViewController"];
    }
    
    // 5.
    if (4 == indexPath.row) {
     
        [self push:@"SZCATransitionViewController"];
    }
    
    // 6.
    if (5 == indexPath.row) {
       
        [self push:@"SZComplexAnimationViewController"];
    }
    
    // 7.
    if (6 == indexPath.row) {
        
    }
    
    // 8.
    if (7 == indexPath.row) {
        
        
    }
    
    // 9.小综合使用
    if (8 == indexPath.row) {
        
       
    }
    
    if (9 == indexPath.row) {
        
        
    }
}

- (void)push:(NSString *)className
{
    Class class = NSClassFromString(className);
    
    [self.navigationController pushViewController:[class new] animated:YES];
}

#pragma mark - lazy load

- (NSArray *)functionList
{
    if (nil == _functionList) {
        
        _functionList = [NSArray array];
        _functionList = @[@"CABasic", @"CASpring", @"CAKeyFrame", @"CAGroup", @"CATransition", @"ComplexAnimation"];
    }
    
    return _functionList;
}

- (NSArray *)functionListChinese
{
    if (nil == _functionListChinese) {
        
        _functionListChinese = [NSArray array];
        _functionListChinese = @[@"基本动画", @"弹性动画", @"关键帧动画", @"组动画", @"转场动画", @"复杂动画"];
    }
    return _functionListChinese;
}

@end
