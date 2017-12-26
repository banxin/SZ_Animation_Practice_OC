//
//  SZFieldViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZFieldViewController.h"

/*
 http://www.jianshu.com/p/9841168e1e92?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
 */

@interface SZFieldViewController ()

@property (strong, nonatomic) UIView *blueView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIFieldBehavior *radialGravityField;
@property (strong, nonatomic) UIFieldBehavior *vortexField;

@end

@implementation SZFieldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.blueView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 1.开启调试模式
    [self.animator setValue:[NSNumber numberWithBool:YES] forKey:@"debugEnabled"];
    
    // 2.配置动力项密度
    UIDynamicItemBehavior *blueViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.blueView]];
    // density：动力项的density和大小，决定了其在动力行为中能受到力大小。一个100p * 100p的动力项，density为1.0，施加1.0的力，会产生100points每平方秒的加速度。
    blueViewBehavior.density = 0.5;
    [self.animator addBehavior:blueViewBehavior];
    
    // 3.添加动力项到动力行为
    [self.vortexField addItem:self.blueView];
    [self.radialGravityField addItem:self.blueView];
    
    // 4.添加动力行为到animator
    [self.animator addBehavior:self.vortexField];
    [self.animator addBehavior:self.radialGravityField];
}

#pragma mark - Properties

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _blueView.center = CGPointMake(self.view.center.x*2/3, self.view.center.y*2/3);
        _blueView.layer.cornerRadius = _blueView.frame.size.width/2;
        _blueView.layer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return _blueView;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIFieldBehavior *)radialGravityField {
    if (!_radialGravityField) {
        // 1.使用类方法初始化radialGravityField
        _radialGravityField = [UIFieldBehavior radialGravityFieldWithPosition:self.view.center];
        // 2.指定radialGravityField区域
        _radialGravityField.region = [[UIRegion alloc] initWithRadius:300];
        // 3.设置场强
//        _radialGravityField.strength = 1.5;
        _radialGravityField.strength = 50;
        // 4.场强随距离变化
        _radialGravityField.falloff = 4.0;
        // 5.场强变化的最小半径
        _radialGravityField.minimumRadius = 50.0;
    }
    return _radialGravityField;
}

- (UIFieldBehavior *)vortexField {
    if (!_vortexField) {
        // 1.初始化vortexField
        _vortexField = [UIFieldBehavior vortexField];
        // 2.设置position为视图中心
        _vortexField.position = self.view.center;
        
        _vortexField.region = [[UIRegion alloc] initWithRadius:200];
        _vortexField.strength = 0.005;
    }
    return _vortexField;
}

@end

























