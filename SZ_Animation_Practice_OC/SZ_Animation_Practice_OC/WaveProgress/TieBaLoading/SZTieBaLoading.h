//
//  SZTieBaLoading.h
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZTieBaLoading : UIView

- (void)show;

- (void)hide;

/**
 * 显示方法
 */
+ (void)showInView:(UIView*)view;

/**
 * 隐藏方法
 */
+ (void)hideInView:(UIView*)view;

@end
