//
//  CASharpLayerListViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "CASharpLayerListViewController.h"
#import "DrawShapeViewController.h"
#import "SinOrCosViewController.h"
#import "SimpleShapeAnimationViewController.h"
#import "CircleShapeAnimationViewController.h"
#import "WeChatEyeViewController.h"

@interface CASharpLayerListViewController ()

@property (nonatomic, strong) NSArray *titleAry;

@end

/*
 http://www.jianshu.com/p/139f4fbe7b6b
 
 一、CAShapeLayer简介
 
 CAShapeLayer属于QuartzCore框架，继承自CALayer。CAShapeLayer是在坐标系内绘制贝塞尔曲线的，通过绘制贝塞尔曲线，设置shape(形状)的path(路径)，从而绘制各种各样的图形以及不规则图形。因此，使用CAShapeLayer需要与UIBezierPath一起使用。
 UIBezierPath类允许你在自定义的 View 中绘制和渲染由直线和曲线组成的路径。你可以在初始化的时候直接为你的UIBezierPath指定一个几何图形。
 通俗点就是UIBezierPath用来指定绘制图形路径，而CAShapeLayer就是根据路径来绘图的。
 
 二、CAShapeLayer属性介绍
 
 定义要呈现的形状的路径。如果路径扩展到层边界之外，只有当正常层屏蔽规则导致该条线时，它才会自动被剪辑到该层。赋值时，路径被复制。默认为null。（注意，虽然路径属性的动画，不隐将动画时创建的属性发生了变化。）
 @property(nullable) CGPathRef path;
 
 填充路径的颜色，或不需要填充。默认颜色为不透明的黑色。
 @property(nullable) CGColorRef fillColor;
 
 当在填充颜色的时候则就需要这种填充规则，值有两种，非零和奇偶数，但默认是非零值。
 @property(copy) NSString *fillRule;
 
 设置描边色，默认无色
 @property(nullable) CGColorRef strokeColor;
 
 这两个值被定义用于绘制边线轮廓路径的子区域。该值必须在[0,1]范围，0代表路径的开始，1代表路径的结束。在0和1之间的值沿路径长度进行线性插值。strokestart默认为0，strokeend默认为1。
 @property CGFloat strokeStart;
 @property CGFloat strokeEnd;
 
 lineWidth为线的宽度，默认为1；miterLimit为最大斜接长度。斜接长度指的是在两条线交汇处和外交之间的距离。只有lineJoin属性为kCALineJoinMiter时miterLimit才有效。边角的角度越小，斜接长度就会越大。为了避免斜接长度过长，我们可以使用miterLimit属性。如果斜接长度超过miterLimit的值，边角会以lineJoin的“bevel”即kCALineJoinBevel类型来显示。
 @property CGFloat lineWidth;
 @property CGFloat miterLimit;
 
 lineCap为线端点类型，值有三个类型，分别为kCALineCapButt 、kCALineCapRound 、kCALineCapSquare，默认值为Butt；lineJoin为线连接类型，其值也有三个类型，分别为kCALineJoinMiter、kCALineJoinRound、kCALineJoinBevel，默认值是Miter。
 /
 kCALineCapButt: 默认格式，不附加任何形状;
 kCALineCapRound: 在线段头尾添加半径为线段 lineWidth 一半的半圆；
 kCALineCapSquare: 在线段头尾添加半径为线段 lineWidth 一半的矩形
 
 NSString *const kCALineJoinMiter,    // 尖角
 NSString *const kCALineJoinRound,    // 圆角
 NSString *const kCALineJoinBevel     // 缺角
 /
 @property(copy) NSString *lineCap;
 @property(copy) NSString *lineJoin;
 
 lineDashPhase为线型模版的起始位置；lineDashPattern为线性模版，这是一个NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度。
 注：fillColor与strokeColor都是在有UIBezierPath参数配置的情况下才能发生作用
 @property CGFloat lineDashPhase;
 @property(nullable, copy) NSArray<NSNumber *> *lineDashPattern;
 
 *** 描边色、填充色这两种颜色需要UIBezierPath来绘制路径，然后使用CAShapeLayer进行渲染，layer的背景与最好不要与这两种颜色共用
 
 */
@implementation CASharpLayerListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Shape 简单使用";
}

#pragma - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleAry[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:
            
            [self pushDrawShape];
            
            break;
            
        case 1:
            
            [self pushSinOrCos];
            
            break;
            
        case 2:
            
            [self pushSimpleAnimation];
            
            break;
            
        case 3:
            
            [self pushCircleAnimation];
            
            break;
            
        case 4:
            
            [self pushWeChatEye];
            
            break;
            
        default:
            
            break;
    }
}

- (void)pushDrawShape
{
    DrawShapeViewController *vc = [DrawShapeViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSinOrCos
{
    SinOrCosViewController *vc = [SinOrCosViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSimpleAnimation
{
    SimpleShapeAnimationViewController *vc = [SimpleShapeAnimationViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushCircleAnimation
{
    CircleShapeAnimationViewController *vc = [CircleShapeAnimationViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWeChatEye
{
    WeChatEyeViewController *vc = [WeChatEyeViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter / setter

- (NSArray *)titleAry
{
    if (!_titleAry) {
        
        _titleAry = @[@"绘制shape", @"绘制曲线（正弦曲线为例）", @"直线和曲线动画", @"圆形动画", @"微信下拉小视频动画"];
    }
    
    return _titleAry;
}

@end





















