//
//  SZGravityViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/8.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZGravityViewController.h"

@interface SZGravityViewController ()

// 力学动画生成器
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

// 重力行为对象
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;

// 碰撞行为对象
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;

// 重力效果对象
@property (nonatomic, strong) UIImageView *gravityEffectView;

// 重力效果对象2
@property (nonatomic, strong) UIImageView *gravityEffectView2;

@end

@implementation SZGravityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    // 1.添加重力效果视图
    [self.view addSubview:self.gravityEffectView];
    
    [self.view addSubview:self.gravityEffectView2];
    
    // 2.设置重力行为
    /*
     方法解析
     
     - (void)setAngle:(CGFloat)angle magnitude:(CGFloat)magnitude;
     主要用来: 设置重力行为的矢量角度和大小
     参数 angle : 重力矢量的弧度,使用标准的 UIKit 几何.如果指定值 M_PI_2 ,也就是90°,那么就是创建一个力,将重力展示视图向下拖动到参考视图的底部.如果是M_PI_4,就是以45°来拖动.
     参数 magnitude: 重力的大小.1.0则表示加速度为 1000 点/秒
     */
    [self.gravityBehavior setAngle:M_PI_2 magnitude:0.35];
    
    // 3.添加到力学动画生成器中
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    
    // --------------------------------------
    
    // 无限下坠无任何意义，所以为 重力效果对象2 添加碰撞行为，碰到边界后会弹跳，不会穿过，然后逐渐停在边界
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    
    /*
     
     另外一个重要的类是UIDynamicItemBehavior，用于修改指定动力项的以下属性：
     
     allowsRotation：BOOL型值，用于指定UIDynamicItem是否旋转。默认值是YES。
     angularResistance：旋转阻力，物体旋转过程的阻力大小。值的范围是0到CGFLOAT_MAX，值越大，阻力越大。
     density：动力项的density和大小，决定了其在动力行为中能受到力大小。一个100p * 100p的动力项，density为1.0，施加1.0的力，会产生100points每平方秒的加速度。
     elasticity：弹力。范围是0到1.0，0表示没有弹性，1.0表示完全弹性碰撞。默认值为0。
     friction：摩擦力。默认值0表示没有摩擦力，1.0表示很强摩擦。为了取得更大摩擦力，可以使用更大值。
     resistance：线性阻力。物体移动过程中受到的阻力。默认值0表示没有线性阻力，上限CGFLOAT_MAX为完全阻力。如果此属性值为1.0，则动态项一旦没有作用力会立即停止。
     anchored：BOOL型值，指定动力项是否固定在当前位置。被固定的动力项参与碰撞时不会被移动，而是像边界一样参与碰撞。默认值是NO。
     */
    
    // UIDynamicItemBehavior用于修改动力项属性，现在初始化一个UIDynamicItemBehavior，修改其elasticity属性
    // 4.初始化UIDynamicItemBehavior 修改elasticity
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.gravityEffectView2]];
    
    // elasticity默认值为0，范围是0到1.0，0表示没有弹性，1.0表示完全弹性碰撞。这里把值设为0.7。
    dynamicItemBehavior.elasticity = 0.7;
    
    [self.dynamicAnimator addBehavior:dynamicItemBehavior];
    
    /*
     UIDynamicBehavior类有void(^action)(void)块属性，其子类也会继承该属性。animator会在每步(step)动画调用该块，也就是action中添加的代码会在动力动画运行过程中不断执行。在testGravity方法初始化graviy后添加以下代码：
     */
//    __weak typeof(self) weakSelf = self;
//
//    self.gravityBehavior.action = ^{
//
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//
//        NSLog(@"gravityEffectView center --> %f", strongSelf.gravityEffectView.center.y);
//
//        NSLog(@"gravityEffectView2 center --> %f", strongSelf.gravityEffectView2.center.y);
//    };
    
    /*
     在上面的代码中，把块赋值给重力行为gravity的action属性，在块中用NSLog输出gravityEffectView中心的y坐标，用以表示其位置。运行app，可以在控制台看到不断输出的数字，并且相邻值的差不断增大，在gravityEffectView离开可见区域后，控制台继续输出。事实上，此时gravityEffectView正在做自由落体运动。
     */
}

#pragma mark -- laze load

// 1.创建力学动画生成器
// self.view 为力学动画生成器的参考视图
- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator) {
        
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    
    return _dynamicAnimator;
}

// 2. 创建重力行为对象
// @[self.gravityEffectView]是用于展示重力行为的视图.自己创建的
- (UIGravityBehavior *)gravityBehavior
{
    if (!_gravityBehavior) {
        
        _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.gravityEffectView, self.gravityEffectView2]];
    }
    
    return _gravityBehavior;
}

// 创建碰撞行为对象
- (UICollisionBehavior *)collisionBehavior
{
    if (!_collisionBehavior) {
        
        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.gravityEffectView2]];
        
        // 1.- (void)addBoundaryWithIdentifier:(id <NSCopying>)identifier fromPoint:(CGPoint)p1 toPoint:(CGPoint)p2;
        // 设定碰撞边界为 self.view 的底部往上偏移 60
        [_collisionBehavior addBoundaryWithIdentifier:@"self.view" fromPoint:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height - 60) toPoint:CGPointMake(self.view.frame.origin.x + self.view.frame.size.width, self.view.frame.origin.y + self.view.frame.size.height - 60)];
        
        /*
         设定碰撞边界的方法：
         
         除上面的添加边界方法外，还有以下三种添加边界的方法：
         
         2.translatesReferenceBoundsIntoBoundary：BOOL类型值，指定是否把reference view作为碰撞边界。默认为NO。
         
         // 另外两个方法，遇到对应的需要的情况再做测试
         3.addBoundaryWithIdentifier: forPath:：添加指定Bezier Path作为碰撞边界。
         4.setTranslatesReferenceBoundsIntoBoundaryWithInsets:：设定某一区域作为碰撞边界。
         */
        
        // 2.translatesReferenceBoundsIntoBoundary：BOOL类型值，指定是否把reference view作为碰撞边界。默认为NO。
        /*
        // 指定是否把reference view作为碰撞边界，默认为NO，该处设定为YES
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        // 设定碰撞模式为，只能与边界碰撞,不能与物体碰撞
        
         // UICollisionBehaviorModeItems // 只能物体间碰撞
         // UICollisionBehaviorModeBoundaries // 只能与边界碰撞,不能与物体碰撞
         // UICollisionBehaviorModeEverything // 与所有东西都可以碰撞
         
         _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
        */
        
    }
    
    return _collisionBehavior;
}

// 创建重力效果对象1
- (UIImageView *)gravityEffectView
{
    if (!_gravityEffectView) {
        
        _gravityEffectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei"]];
        
        _gravityEffectView.frame = CGRectMake(100, 100, 100, 100);
    }
    
    return _gravityEffectView;
}

// 创建重力效果对象2
- (UIImageView *)gravityEffectView2
{
    if (!_gravityEffectView2) {
        
        _gravityEffectView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"路飞"]];
        
        _gravityEffectView2.frame = CGRectMake(240, 100, 100, 100);
    }
    
    return _gravityEffectView2;
}

@end














