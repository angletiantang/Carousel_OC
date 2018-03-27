//
//  CarouselScrollView.h
//  Carousel_OC
//
//  Created by guojianheng on 2018/3/27.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"

// 设置回调代理
@protocol CarouselScrollViewDelegate <NSObject>
/* 图片点击事件的回调**/
-(void)carouselImageViewClicked:(NSInteger)index;

@end

@interface CarouselScrollView : UIView<UIScrollViewDelegate>

// MARK: - 属性
// 是否URL加载
@property (nonatomic , assign)BOOL isFromURL;
// 页码
@property (nonatomic , assign)NSInteger index;
// 图片数量
@property (nonatomic , assign)NSInteger imgViewNum;
// 宽度
@property (nonatomic , assign)CGFloat sWidth;
// 高度
@property (nonatomic , assign)CGFloat sHeight;
// 图片每一页停留时间
@property (nonatomic , assign)NSTimeInterval pageStepTime;

// 定时器
@property (nonatomic , strong)NSTimer * timer;
// 图片数组
@property (nonatomic , strong)NSArray * imgArray;
// 图片url数组
@property (nonatomic , strong)NSArray * imgURLArray;

// MARL: - 懒加载
// 图片滚动view
@property (nonatomic , strong)UIScrollView * scrollView;
// pageControl
@property (nonatomic , strong)UIPageControl * pageControl;

// 代理属性
@property(nonatomic, weak)id<CarouselScrollViewDelegate>delegate;

/**
 初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
 
 - parameter frame:          frame
 - parameter imgURLArray:    图片URL数组
 - parameter pagePointColor: pageControl的当前page点的颜色
 - parameter stepTime:       图片每一页停留时间
 
 - returns: ScrollView图片轮播器
 */
- (instancetype)initWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray pagePointColor:(UIColor *)pagePointColor stepTime:(NSTimeInterval)stepTime;

/**
 初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
 
 - parameter frame:          frame
 - parameter imgArray:       图片数组
 - parameter pagePointColor: pageControl的当前page点的颜色
 - parameter stepTime:       图片每一页停留时间
 
 - returns: ScrollView图片轮播器
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imgArray pagePointColor:(UIColor *)pagePointColor stepTime:(NSTimeInterval)stepTime;

@end
