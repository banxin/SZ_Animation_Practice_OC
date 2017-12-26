//
//  SZAttachmentViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/8.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZAttachmentViewController.h"

/*
 1.概念
 
 连接(attachment)指定了两个物体之间的动态连接.让一个物体的行为和移动受制于另一个物体的移动.
 默认情况下, UIAttachmentBehaviors 将物体的中心指定为连接点,但可将任何点指定为连接点
 */

@interface SZAttachmentViewController ()

@property (nonatomic, strong) UIImageView *imageView_first;
@property (nonatomic, strong) UIImageView *imageView_second;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;

@property (assign, nonatomic) CGRect originalBounds;
@property (assign, nonatomic) CGPoint originalCenter;

@end

@implementation SZAttachmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    [self.view addSubview:self.imageView_first];
    [self.view addSubview:self.imageView_second];
    
    self.originalBounds = self.imageView_first.bounds;
    self.originalCenter = self.imageView_first.center;
    
//    [self addPanGesture];
    [self addTapGesture];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    // 加了边界碰撞image会闪，具体原因不明（求大神告知！！！）
//    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.attachmentBehavior];
}

- (void)addTapGesture
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];

    [self.view addGestureRecognizer:tapGes];
}

- (void)tapMethod:(UITapGestureRecognizer *)tap
{
    CGPoint panPoint = [tap locationInView:self.view];
    self.imageView_second.center = panPoint;
    [self.attachmentBehavior setAnchorPoint:panPoint];
}

// 添加平移手势
- (void)addPanGesture
{
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
    self.imageView_second.userInteractionEnabled = YES;
    [self.imageView_second addGestureRecognizer:panGes];
}

- (void)panMethod:(UIPanGestureRecognizer *)panGesture
{
    CGPoint panPoint = [panGesture locationInView:self.view];
    self.imageView_second.center = panPoint;
    [self.attachmentBehavior setAnchorPoint:panPoint];
}

#pragma mark - lazy load

- (UIImageView *)imageView_first {
    if (nil == _imageView_first) {
        _imageView_first = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"路飞"]];
        _imageView_first.frame = CGRectMake(50, 100, 100, 100);
    }
    return _imageView_first;
}

- (UIImageView *)imageView_second {
    if (nil == _imageView_second) {
        _imageView_second = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei"]];
        _imageView_second.frame = CGRectMake(200, 300, 100, 100);
    }
    return _imageView_second;
}

- (UIDynamicAnimator *)dynamicAnimator {
    if (nil == _dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _dynamicAnimator;
}

- (UIGravityBehavior *)gravityBehavior {
    if (nil == _gravityBehavior) {
        _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.imageView_first]];
        [_gravityBehavior setAngle:M_PI_2 magnitude:0.3];
    }
    return _gravityBehavior;
}

- (UICollisionBehavior *)collisionBehavior
{
    if (nil == _collisionBehavior) {

        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.imageView_first,self.imageView_second]];

//        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.imageView_second]];

//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 69, self.view.frame.size.width - 10, self.view.frame.size.height - 74) cornerRadius:20];
//
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//
//        shapeLayer.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4].CGColor;
//        shapeLayer.fillColor = [UIColor clearColor].CGColor;
//        shapeLayer.lineWidth = 1;
//        shapeLayer.lineJoin = kCALineJoinRound;
//        shapeLayer.lineCap = kCALineCapRound;
//        shapeLayer.path = path.CGPath;
//
//        [self.view.layer addSublayer:shapeLayer];
//
//        // 设定 BezierPath 边界
//        [_collisionBehavior addBoundaryWithIdentifier:@"collisionBehavior" forPath:path];

        _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collisionBehavior;
}

- (UIAttachmentBehavior *)attachmentBehavior {
    if (nil == _attachmentBehavior) {

        _attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.imageView_first attachedToAnchor:CGPointMake(self.imageView_second.center.x,self.imageView_second.center.y)];
        
//        [_attachmentBehavior setLength:200.0f];     // 设置连接的长度
    }
    return _attachmentBehavior;
}

@end






























