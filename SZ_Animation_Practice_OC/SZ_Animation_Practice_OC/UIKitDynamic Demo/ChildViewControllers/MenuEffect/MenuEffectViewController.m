//
//  MenuEffectViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/8.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "MenuEffectViewController.h"

/*
 示例想要达到的效果为：使用UISwipeGestureRecognizer手势自左向右滑，从左侧弹出一个占据半个屏幕的菜单。使用同样手势自右向左滑动，隐藏弹出菜单。在弹出菜单后面，另一个半透明的视图将会显示在主视图之上，防止误点击到主视图；当弹出菜单隐藏时，半透明视图隐藏。菜单视图、表视图和背景视图共同用于显示弹出项，UIDynamicAnimator处理所有动画。
 */

// 指定menuView的宽度为视图控制器视图宽度的二分之一
#define menuWidth self.view.frame.size.width / 2
static NSString * const reuseIdentifier = @"CellIdentifier";

@interface MenuEffectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *menuTable;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation MenuEffectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MenuEffect";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupMainView];
    
    [self addGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self cleanView];
}

- (void)cleanView
{
    [self.backgroundView removeFromSuperview];
    [self.menuView removeFromSuperview];
}

- (void)setupMainView
{
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 * 2, self.view.frame.size.width, 20)];
    
    lblTips.font = [UIFont systemFontOfSize:16.f];
    lblTips.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.text = @"向右轻扫试试，有惊喜哦！！！";
    
    [self.view addSubview:lblTips];
    
    // 添加背景视图 菜单视图 表视图
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.menuView];
    [self.menuView addSubview:self.menuTable];
    
    // 注册cell
    [self.menuTable registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

/*
 在主屏幕上使用手势右滑，menuView出现；在menuView上左滑，menuView隐藏。最方便的方法就是当手势触发时调用同一个方法，在调用方法内根据手势方向调用toggleMenu:方法，并设置对应参数。
 
 添加手势
 */
- (void)addGesture
{
    // self.view添加右滑手势
    UISwipeGestureRecognizer *showMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    showMenuGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:showMenuGesture];
    
    // menuView添加左滑手势
    UISwipeGestureRecognizer *hideMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    hideMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.menuView addGestureRecognizer:hideMenuGesture];
    
    {
        // backgroundView添加左滑手势
        UISwipeGestureRecognizer *hideMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        hideMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.backgroundView addGestureRecognizer:hideMenuGesture];
    }
    
    // backgroundView添加点击事件
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGestureWithTap)];
    
    [self.backgroundView addGestureRecognizer:hideTap];
}

- (void)hideGestureWithTap
{
    [self handleGesture:nil];
}

- (void)handleGesture:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self toggleMenu:YES];
        
    } else {
        
        [self toggleMenu:NO];
    }
}

/*
 现在开始实现弹出、隐藏动画部分。如果我们仔细考虑一下，你会发现菜单视图弹出和隐藏的动画是相同的，只是方向相反。这意味着可以在一个方法内定义动力行为，其方向根据menuView所处状态而定。
 
 在实现之前，先看一下要显示菜单的动力行为。首先，需要一个碰撞行为，以便让视图在指定边界发生碰撞，而不是从屏幕一边滑动到另一边。其次，添加方向向右的重力行为，以便让menuView看起来像被边界拖拽着滑动。再添加一个UIDynamicItemBehavior属性中的elasticity，这样看起来就很好了。但还可以添加一个UIPushBehavior让menuView移动的快一些。在隐藏menuView时使用相同动力行为，只是方向相反。
 */

// 实现动画的主要部分
/*
 代码每一步都很简单，这里有以下几点需要注意：
 
 1.在代码开始部分，移除animator内所有动力行为。因为当使用相反手势，隐藏menuView时，需要添加的行为与已存在的行为冲突，同时存在动画不能正常运行。
 2.初始化推力行为中参数mode:有两个可用参数，UIPushBehaviorModeInstantaneous表示施加瞬时力，即一个冲量；UIPushBehaviorModeContinuous表示施加连续的力。
 3.backgroundView的alpha由现在所处状态决定。
 
 -- 如果你想要施加的重力需要结合物体自身质量，请使用后面讲到的UIFieldBehavior，力场行为支持线性和径向引力场，其引力大小和动力项自身质量有关，且力大小与距场行为中心远近相关，导致施加到不同物体上的力大小不同。
 
 */
- (void)toggleMenu:(BOOL)shouldOpenMenu
{
    // 移除所有动力行为
    [self.animator removeAllBehaviors];
    
    // 根据参数shouldOpenMenu 获取重力方向 推力方向 边界位置
    // 重力方向
    CGFloat gravityDirectionX = shouldOpenMenu ? 1.0 : -1.0;
    // 推力方向
    CGFloat pushMagnitude = shouldOpenMenu ? 20.0 : -20.0;
    // 边界位置
    CGFloat boundaryPointX = shouldOpenMenu ? menuWidth : -menuWidth;
    
    // 添加重力行为
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.menuView]];
    
    // 也可以使用 gravity.angle = 0; （是一个角度）
    // 设置重力的方向（是一个二维向量）
    /*
     重力方向（二维向量）
     
     说明：给定坐标平面内的一个点。然后用原点（0，0）来连接它，就构成了一个向量。
     
     注意：在IOS中以左上角为坐标原点，向右x增加，向下Y越大。
     */
    gravityBehavior.gravityDirection = CGVectorMake(gravityDirectionX, 0);
    
    [self.animator addBehavior:gravityBehavior];
    
    // 添加碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"menuBoundary" fromPoint:CGPointMake(boundaryPointX, 64) toPoint:CGPointMake(boundaryPointX, self.view.frame.size.height - 64)];
    
    [self.animator addBehavior:collisionBehavior];
    
    // 添加推力行为
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.menuView] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehavior.magnitude = pushMagnitude;
    
    [self.animator addBehavior:pushBehavior];
    
    // 设置menuView的elasticity属性
    UIDynamicItemBehavior *menuViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.menuView]];
    
    // elasticity默认值为0，范围是0到1.0，0表示没有弹性，1.0表示完全弹性碰撞。这里把值设为0.7。
    menuViewBehavior.elasticity = 0.4;
    
    [self.animator addBehavior:menuViewBehavior];
    
    //  设置backgroundView alpha值
    self.backgroundView.alpha = shouldOpenMenu ? 0.5 : 0;
    self.backgroundView.hidden = shouldOpenMenu ? NO : YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Option %li",indexPath.row + 1];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

#pragma mark -- lazy load

// 1.设置背景视图
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
        _backgroundView.backgroundColor = [UIColor lightGrayColor];
        _backgroundView.alpha = 0.0;
    }
    return _backgroundView;
}

// 2.设置菜单视图
- (UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(-menuWidth, 64, menuWidth, self.view.frame.size.height - 64)];
        _menuView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return _menuView;
}

// 3.设置表视图
- (UITableView *)menuTable
{
    if (!_menuTable) {
        _menuTable = [[UITableView alloc] initWithFrame:self.menuView.bounds style:UITableViewStylePlain];
        _menuTable.backgroundColor = [UIColor clearColor];
        _menuTable.alpha = 1.0;
        _menuTable.scrollEnabled = NO;
        _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _menuTable.delegate = self;
        _menuTable.dataSource = self;
    }
    return _menuTable;
}

// 4.初始化UIDynamicAnimator
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

@end
