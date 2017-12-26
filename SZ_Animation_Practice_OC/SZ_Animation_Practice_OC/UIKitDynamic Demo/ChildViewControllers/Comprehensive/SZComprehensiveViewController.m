//
//  SZComprehensiveViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "SZComprehensiveViewController.h"

/*
 http://www.jianshu.com/p/9841168e1e92?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
 */

@interface SZComprehensiveViewController ()

@property (strong, nonatomic) UIImageView *imageView;
/*
 redView和blueView用于表示UIDynamics物理引擎动画的点，blueView表示触摸开始的点，redView表示表示手指触摸点，也是imageView的锚点
 */
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UIView *blueView;
@property (assign, nonatomic) CGRect originalBounds;
@property (assign, nonatomic) CGPoint originalCenter;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;

@end

// 表示imageView要想继续移动而不立即返回到原始位置所需要的最低速度
static CGFloat const ThrowingThreshold = 1000;
// 用于影响推力大小
static CGFloat const ThrowingVelocityPadding = 15;

@implementation SZComprehensiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.originalBounds = self.imageView.bounds;
    self.originalCenter = self.imageView.center;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.redView];
    [self.view addSubview:self.blueView];
    
    // 为imageView添加平移手势识别器
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAttachmentGesture:)];
    [self.imageView addGestureRecognizer:pan];
}

#pragma mark - IBAction

- (void)handleAttachmentGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = [panGesture locationInView:self.view];
    CGPoint boxLocation = [panGesture locationInView:self.imageView];
    
    switch (panGesture.state) {
            
            // 手势开始
        case UIGestureRecognizerStateBegan:
 
            // 1.如果存在动力行为 则移除所有动力行为
            [self.animator removeAllBehaviors];
            
            // 2.通过改变锚点移动imageView
            UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.imageView.bounds), boxLocation.y - CGRectGetMidY(self.imageView.bounds));
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.imageView offsetFromCenter:centerOffset attachedToAnchor:location];
            
            // 3.redView中心设置为attachmentBehavior的anchorPoint  blueView的中心设置为手势手势开始的位置
            self.redView.center = self.attachmentBehavior.anchorPoint;
            self.blueView.center = location;
            
            // 4.添加附着行为到animator
            self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            [self.animator addBehavior:self.attachmentBehavior];
            
            // 添加边界，让logo不能跳出屏幕之外
//            self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.imageView]];
//
////            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 69, self.view.frame.size.width - 10, self.view.frame.size.height - 74) cornerRadius:20];
////
////            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
////
////            shapeLayer.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4].CGColor;
////            shapeLayer.fillColor = [UIColor clearColor].CGColor;
////            shapeLayer.lineWidth = 1;
////            shapeLayer.lineJoin = kCALineJoinRound;
////            shapeLayer.lineCap = kCALineCapRound;
////            shapeLayer.path = path.CGPath;
////
////            [self.view.layer addSublayer:shapeLayer];
////
////            // 设定 BezierPath 边界
////            [self.collisionBehavior addBoundaryWithIdentifier:@"collisionBehavior" forPath:path];
////
//            _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//            self.collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
//
//            [self.animator addBehavior:self.collisionBehavior];
            
            break;
            
            // 手势改变
        case UIGestureRecognizerStateChanged:
            self.attachmentBehavior.anchorPoint = [panGesture locationInView:self.view];
            self.redView.center = self.attachmentBehavior.anchorPoint;
            break;
            
            // 手势结束
        case UIGestureRecognizerStateEnded:
            //            NSLog(@"Touch ended position: %@",NSStringFromCGPoint(location));
            //            NSLog(@"Location in image ended is %@",NSStringFromCGPoint(boxLocation));
            // 1.移除attachmentBehavior
            [self.animator removeBehavior:self.attachmentBehavior];
            
            // 2.当前运行速度 推动行为力向量大小
            CGPoint velocity = [panGesture velocityInView:self.view];
            CGFloat magnitude = sqrtf(velocity.x * velocity.x + velocity.y * velocity.y);
            
            if (magnitude > ThrowingThreshold) {
                // 3.添加pushBehavior
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.imageView] mode:UIPushBehaviorModeInstantaneous];
                pushBehavior.pushDirection = CGVectorMake(velocity.x / 10, velocity.y / 10);
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                
                self.pushBehavior = pushBehavior;
                [self.animator addBehavior:self.pushBehavior];
                
                // 4.修改itemBehavior属性 以便让imageView产生飞起来的感觉
                NSInteger angle = arc4random_uniform(20) - 10;
                
                self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imageView]];
                self.itemBehavior.friction = 0.2;
                self.itemBehavior.allowsRotation = YES;
                [self.itemBehavior addAngularVelocity:angle forItem:self.imageView];
                [self.animator addBehavior:self.itemBehavior];
                
                // 5.一定时间后 imageView回到初始位置
                [self performSelector:@selector(resetDemo) withObject:nil afterDelay:0.3];
            }
            else
            {
                [self resetDemo];
            }
            
            break;
            
        default:
            break;
    }
}

/** 函数解析
 * double pow(double x, double y）;       计算以x为底数的y次幂
 * float powf(float x, float y);          功能与pow一致，只是输入与输出皆为浮点数
 * double sqrt (double);                  开平方
 * double atan2 (double, double);         反正切(整圆值), 结果介于[-PI, PI]
 */

- (void)resetDemo {
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.bounds = self.originalBounds;
        self.imageView.center = self.originalCenter;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Properties

- (UIImageView *)imageView {
    if (!_imageView) {
        CGPoint center = self.view.center;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
        _imageView.center = CGPointMake(center.x, center.y*2/3);
        _imageView.image = [UIImage imageNamed:@"AppleLogo.jpg"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redView.center = CGPointMake(self.view.center.x, self.view.center.y*2/3);
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(80, 400, 10, 10)];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

@end
































