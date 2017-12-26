//
//  SZCircleLayer.h
//  WaveDemo
//
//  Created by yanl on 2017/12/11.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SZCircleLayer : CAShapeLayer

UIKIT_EXTERN const CGFloat AnimationTime;

// 缩放动画
- (CGFloat)scaleAnimation:(BOOL)toBig;

// 挤压动画
- (CGFloat)extrusionAnimation;

@end
