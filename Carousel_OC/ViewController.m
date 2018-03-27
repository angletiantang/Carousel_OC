//
//  ViewController.m
//  Carousel_OC
//
//  Created by guojianheng on 2018/3/27.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "ViewController.h"
#import "CarouselScrollView.h"

@interface ViewController ()<CarouselScrollViewDelegate>

// 数据数组
@property (nonatomic , strong)NSArray * imagesArray;
// CarouselScrollView轮播View
@property (nonatomic , strong)CarouselScrollView * carouselView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取数据
    [self getURLData];
    
    // 如果是navigationController,必须加上下面的方法
    // 如果不是，则不需要
    self.navigationController.navigationBar.translucent = NO;
    
    // 创建carouselView
    [self layoutCarouselView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getURLData
{
    // 图片集合
    self.imagesArray = @[@"http://img.taopic.com/uploads/allimg/120727/201995-120HG1030762.jpg",
                         @"http://img.taopic.com/uploads/allimg/140421/318743-140421213T910.jpg",
                         @"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png",
                         @"http://img.zcool.cn/community/0166e959ac1386a801211d25c63563.jpg@1280w_1l_2o_100sh.jpg",
                         @"http://img.taopic.com/uploads/allimg/140729/240450-140HZP45790.jpg"];
}

- (void)layoutCarouselView
{
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    self.carouselView = [[CarouselScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/16*9) imageURLArray:self.imagesArray pagePointColor:[UIColor greenColor] stepTime:1.0];
    // 代理 后面需要实现
    self.carouselView.delegate = self;
    [self.view addSubview:self.carouselView];
    
}

#pragma mark ----- 代理的实现部分 -----
- (void)carouselImageViewClicked:(NSInteger)index
{
    NSLog(@"%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
