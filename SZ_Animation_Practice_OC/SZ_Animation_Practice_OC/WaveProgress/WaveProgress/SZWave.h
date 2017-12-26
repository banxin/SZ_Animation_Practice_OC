//
//  SZWave.h
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZWave : UIView

/**
 设置进度 0~1
 */
@property (nonatomic, assign) CGFloat progress;

- (void)stop;

@end
