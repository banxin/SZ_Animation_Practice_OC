//
//  SZWaveLoadingView.h
//  WaveDemo
//
//  Created by yanl on 2017/11/24.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 如果需要每个属性或每个方法都去指定nonnull和nullable，是一件非常繁琐的事。苹果为了减轻我们的工作量，专门提供了两个宏：NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END。在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针
 */
NS_ASSUME_NONNULL_BEGIN

@interface SZWaveLoadingView : UIView

/**
 初始化

 @return waveLoadingView
 */
+ (instancetype)loadingView;

/**
开始动画
 */
- (void)startLoading;

/**
 结束动画
 */
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
