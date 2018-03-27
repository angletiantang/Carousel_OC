//
//  CarouselScrollView.m
//  Carousel_OC
//
//  Created by guojianheng on 2018/3/27.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "CarouselScrollView.h"

@implementation CarouselScrollView

// MARK: - 初始化方法
/**
 初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
 
 - parameter frame:          frame
 - parameter imgURLArray:    图片URL数组
 - parameter pagePointColor: pageControl的当前page点的颜色
 - parameter stepTime:       图片每一页停留时间
 
 - returns: ScrollView图片轮播器
 */
- (instancetype)initWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray pagePointColor:(UIColor *)pagePointColor stepTime:(NSTimeInterval)stepTime
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgURLArray = imageURLArray;
        self.isFromURL = YES;
        [self prepareUIWithNumberOfImage:imageURLArray.count pagePointColor:pagePointColor stepTime:stepTime];
    }
    return self;
}

/**
 初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
 
 - parameter frame:          frame
 - parameter imgArray:       图片数组
 - parameter pagePointColor: pageControl的当前page点的颜色
 - parameter stepTime:       图片每一页停留时间
 
 - returns: ScrollView图片轮播器
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imgArray pagePointColor:(UIColor *)pagePointColor stepTime:(NSTimeInterval)stepTime
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgArray = imgArray;
        self.isFromURL = NO;
        [self prepareUIWithNumberOfImage:imgArray.count pagePointColor:pagePointColor stepTime:stepTime];
    }
    return self;
}

// MARK: - 准备UI
- (void)prepareUIWithNumberOfImage:(NSInteger)numberOfImage pagePointColor:(UIColor *)pagePointColor stepTime: (NSTimeInterval)stepTime
{
    // 设置图片数量
    self.imgViewNum = numberOfImage;
    // 设置图片每一页的停留时间
    self.pageStepTime = stepTime;
    
    //布局ScrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    //布局pageControl
    self.pageControl = [[UIPageControl alloc]init];
    CGFloat pW = self.scrollView.bounds.size.width;
    CGFloat pH = 15;
    CGFloat pX = 0;
    CGFloat pY = self.scrollView.bounds.size.height - (pH * 2);
    self.pageControl.frame = CGRectMake(pX, pY, pW, pH);
    
    // 添加ScrollView
    [self addSubview:self.scrollView];
    // 添加pageControl
    [self addSubview:self.pageControl];
    
    // pageControl数量
    self.pageControl.numberOfPages = self.imgViewNum;
    //pageControl颜色
    self.pageControl.currentPageIndicatorTintColor = pagePointColor;
    // view宽度
    self.sWidth = self.frame.size.width;
    // view高度
    self.sHeight = self.frame.size.height;
    
    // 设置代理
    self.scrollView.delegate = self;
    // 一页页滚动
    self.scrollView.pagingEnabled = YES;
    // 隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 设置一开始偏移量
    self.scrollView.contentOffset = CGPointMake(self.sWidth, 0);
    
    // 设置timer
    [self setTheTimer];
    // 设置图片
    [self prepareImage];
    
}

// MARK:设置timer
- (void)setTheTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pageStepTime target:self selector:@selector(nextImage) userInfo:nil repeats:nil];
    
    NSRunLoop * runloop = [NSRunLoop currentRunLoop];
    
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 销毁timer
 */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

// 设置图片的方法
- (void)prepareImage
{
    // 1.获取主队列
    dispatch_queue_t queue=dispatch_get_main_queue();
    // 2.把任务添加到主队列中执行
    dispatch_async(queue, ^{
        // 设置一开始偏移量
        self.scrollView.contentOffset = CGPointMake(self.sWidth,0);
        // 设置滚动范围
        self.scrollView.contentSize = CGSizeMake((self.imgViewNum + 2) * self.sWidth,0);
    });
    for (int i = 0 ; i < self.imgViewNum + 2 ; i ++ ) {
        CGFloat imgX = i * self.sWidth;
        CGFloat imgY = 0;
        CGFloat imgW = self.sWidth;
        CGFloat imgH = self.sHeight;
        UIImageView * imgView = [[UIImageView alloc]init];
        
        if (i == 0)
        {
            // 第0张 显示图片最后一张
            imgX = 0;
            if (self.isFromURL != YES)
            {
                imgView.image = self.imgArray.lastObject;
            }
            else
            {
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgURLArray.lastObject] placeholderImage:[UIImage imageNamed:@"holder"]];
            }
        }
        else if (i == self.imgViewNum + 1)
        {
            //第n+1张,显示图片第一张
            imgX = (self.imgViewNum + 1) * self.sWidth;
            
            if (self.isFromURL != YES)
            {
                imgView.image = self.imgArray.firstObject;
            }
            else
            {
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgURLArray.firstObject] placeholderImage:[UIImage imageNamed:@"holder"]];
            }
        }
        else
        {
            //正常显示图片
            if (self.isFromURL != YES)
            {
                imgView.image = self.imgArray[i - 1];
            }
            else
            {
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgURLArray[i-1]] placeholderImage:[UIImage imageNamed:@"holder"]];
            }
        }
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        //添加子控件
        [self.scrollView addSubview:imgView];
        
        // 开启用户交互
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClicked)];
        [imgView addGestureRecognizer:tapGR];
    }
}

/**
 *  轻拍图片
 */
- (void)imgViewClicked
{
    CGFloat index = self.pageControl.currentPage;
    if (self.delegate && [self.delegate respondsToSelector:@selector(carouselImageViewClicked:)]) {
        [self.delegate carouselImageViewClicked:index];
    }
}

/**
 *  计算滚动页码
 */
- (void)carousel
{
    //获取偏移值
    CGFloat offset = self.scrollView.contentOffset.x;
    //当前页
    NSInteger page = (offset + self.sWidth/2) / self.sWidth;
    //如果是N+1页
    if (page == self.imgViewNum + 1)
    {
        //瞬间跳转第1页
        [self.scrollView setContentOffset:CGPointMake(self.sWidth, 0) animated:NO];
        self.index = 1;
    }
    //如果是第0页
    else if (page == 0)
    {
        //瞬间跳转最后一页
        [self.scrollView setContentOffset:CGPointMake(self.imgViewNum * self.sWidth, 0) animated:NO];
    }
}

// 下一张图片的方法
- (void)nextImage
{
    // 取得当前pageControl页码
    NSInteger indexP = self.pageControl.currentPage;
    
    if (indexP == self.imgViewNum)
    {
        indexP = 1;
    }
    else
    {
        indexP += 1;
    }
    
    [self.scrollView setContentOffset:CGPointMake((indexP + 1) * self.sWidth, 0) animated:YES];
}



#pragma mark ----- ScrollView代理方法 -----

/**
 *  滚动时判断页码
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取偏移值
    CGFloat offset = scrollView.contentOffset.x - self.sWidth;
    // 计算页码
    NSInteger pageIndex = (offset + self.sWidth / 2.0) / self.sWidth;
    // 设置当前页
    self.pageControl.currentPage = pageIndex;
}

/**
 *  结束拖拽时重新创建timer
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setTheTimer];
}

/**
 *  拖拽图片时停止timer
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

/**
 * 动画结束时的判断
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self carousel];
    [self setTheTimer];
}

/**
 *  拖拽减速时的判断
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self carousel];
}

@end
