//
//  ViewController.m
//  FWCycleScrollView_OC
//
//  Created by xfg on 2018/4/3.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "ViewController.h"
#import <FWCycleScrollView/FWCycleScrollView-Swift.h>

@interface ViewController ()

@property (nonatomic, strong) UIScrollView          *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = UIColor.clearColor;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    
    NSArray *adArray = @[@"ad_1", @"ad_2", @"ad_3"];
    NSArray *adArray2 = @[@"ad_4", @"ad_5", @"ad_6"];
    NSArray *adArray3 = @[@"ad_5", @"ad_6", @"ad_7"];
    NSArray *adArray4 = @[@"ad_1", @"ad_2", @"ad_3", @"ad_4", @"ad_5", @"ad_6", @"ad_7"];
    
    NSArray *netAdArray = @[@"http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                            @"http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                            @"http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                            @"http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"
                            ];
    
    // 例一：简单使用、默认分页控件
    FWCycleScrollView *cycleScrollView1 = [FWCycleScrollView cycleImageWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 180)];
    cycleScrollView1.localizationImageNameArray = adArray;
    [self.scrollView addSubview:cycleScrollView1];
    
    
    
    // 例二：点击广告位回调、纵向滚动、自定义分页控件
    FWCycleScrollView *cycleScrollView2 = [FWCycleScrollView cycleImageWithImageUrlStrArray:netAdArray placeholderImage:[UIImage imageNamed:@"ad_placeholder"] frame:CGRectMake(0, CGRectGetMaxY(cycleScrollView1.frame) + 20, self.view.frame.size.width, 140)];
    
    cycleScrollView2.autoScrollTimeInterval = 2.0;
    
    // 对自定义也分控件的设置
    cycleScrollView2.pageControlAliment = PageControlAlimentRight;
    cycleScrollView2.currentPageDotEnlargeTimes = 1.0;
    cycleScrollView2.customDotViewType = FWCustomDotViewTypeSolid;
    cycleScrollView2.pageControlDotSize = CGSizeMake(12, 12);
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView2.currentPageDotColor = [UIColor redColor];
    cycleScrollView2.pageDotColor = [UIColor whiteColor];
    cycleScrollView2.pageControlMargin = 15;
    
    cycleScrollView2.itemDidClickedBlock = ^(NSInteger index){
        NSLog(@"当前点击了第 %ld 个广告位",(index + 1));
    };
    cycleScrollView2.itemDidScrollBlock = ^(NSInteger index){
        //        NSLog(@"当前轮播到了第 %ld 个广告位",(index + 1));
    };
    
    [self.scrollView addSubview:cycleScrollView2];
    
    
    // 例三：自定义图片分页控件
    FWCycleScrollView *cycleScrollView3 = [FWCycleScrollView cycleImageWithLocalizationImageNameArray:adArray3 frame:CGRectMake(0, CGRectGetMaxY(cycleScrollView2.frame) + 20, self.view.frame.size.width, 180)];
    [cycleScrollView3 setupDotImageWithPageDotImage:[UIImage imageNamed:@"pageControlDot"] currentPageDotImage:[UIImage imageNamed:@"pageControlCurrentDot"]];
    cycleScrollView3.autoScrollTimeInterval = 2.5;
    cycleScrollView3.itemDidClickedBlock = ^(NSInteger index){
        NSLog(@"当前点击了第 %ld 个广告位",(index + 1));
    };
    cycleScrollView3.itemDidScrollBlock = ^(NSInteger index){
        //        NSLog(@"当前轮播到了第 %ld 个广告位",(index + 1));
    };
    [self.scrollView addSubview:cycleScrollView3];
    
    
    // 例四：加载网络图片、自定义空心分页控件
    FWCycleScrollView *cycleScrollView4 = [FWCycleScrollView cycleImageWithImageUrlStrArray:netAdArray placeholderImage:[UIImage imageNamed:@"ad_placeholder"] frame:CGRectMake(0, CGRectGetMaxY(cycleScrollView3.frame) + 20, self.view.frame.size.width, 140)];
    
    cycleScrollView4.currentPageDotEnlargeTimes = 1.2;
    cycleScrollView4.customDotViewType = FWCustomDotViewTypeHollow;
    cycleScrollView4.currentPageDotColor = [UIColor whiteColor];
    cycleScrollView4.pageDotColor = [UIColor whiteColor];
    cycleScrollView4.pageControlDotSize = CGSizeMake(10, 10);
    cycleScrollView4.autoScrollTimeInterval = 2.0;
    
    cycleScrollView4.itemDidClickedBlock = ^(NSInteger index){
        NSLog(@"当前点击了第 %ld 个广告位",(index + 1));
    };
    cycleScrollView4.itemDidScrollBlock = ^(NSInteger index){
        //        NSLog(@"当前轮播到了第 %ld 个广告位",(index + 1));
    };
    
    [self.scrollView addSubview:cycleScrollView4];
    
    
    
    // 例五：默认分页控件
    FWCycleScrollView *cycleScrollView5 = [FWCycleScrollView cycleImageWithLocalizationImageNameArray:adArray3 frame:CGRectMake(0, CGRectGetMaxY(cycleScrollView4.frame) + 20, self.view.frame.size.width, 140)];
    cycleScrollView5.pageControlType = PageControlTypeClassic;
    cycleScrollView5.currentPageDotColor = [UIColor lightGrayColor];
    cycleScrollView5.pageDotColor = [UIColor yellowColor];
    cycleScrollView4.pageControlDotSize = CGSizeMake(12, 12);
    cycleScrollView5.autoScrollTimeInterval = 2.0;
    cycleScrollView5.itemDidClickedBlock = ^(NSInteger index){
        NSLog(@"当前点击了第 %ld 个广告位",(index + 1));
    };
    cycleScrollView5.itemDidScrollBlock = ^(NSInteger index){
        //        NSLog(@"当前轮播到了第 %ld 个广告位",(index + 1));
    };
    [self.scrollView addSubview:cycleScrollView5];
    
    
    
    // 例六：轮播自定义视图
    NSArray *customViewArray = @[[self setupUIView:0],
                                 [self setupUIView:1],
                                 [self setupUIView:2],
                                 [self setupUIView:3],
                                 [self setupUIView:4]];
    
    FWCycleScrollView *cycleScrollView6 = [FWCycleScrollView cycleViewWithViewArray:customViewArray frame:CGRectMake(0, CGRectGetMaxY(cycleScrollView5.frame) + 20, self.view.frame.size.width, 140)];
    cycleScrollView6.currentPageDotEnlargeTimes = 1.0;
    cycleScrollView6.customDotViewType = FWCustomDotViewTypeHollow;
    cycleScrollView6.pageDotColor = [UIColor redColor];
    cycleScrollView6.currentPageDotColor = [UIColor redColor];
    cycleScrollView6.pageControlDotSize = CGSizeMake(12, 12);
    cycleScrollView6.autoScrollTimeInterval = 2.0;
    cycleScrollView6.itemDidClickedBlock = ^(NSInteger index){
        NSLog(@"当前点击了第 %ld 个广告位",(index + 1));
    };
    cycleScrollView6.itemDidScrollBlock = ^(NSInteger index){
        //        NSLog(@"当前轮播到了第 %ld 个广告位",(index + 1));
    };
    [self.scrollView addSubview:cycleScrollView6];
    
    
    
    // 例七：轮播自定义视图
    NSArray *customViewArray2 = @[[self setupUIView2:0],
                                 [self setupUIView2:1],
                                 [self setupUIView2:2],
                                 [self setupUIView2:3],
                                 [self setupUIView2:4]];
    
    FWCycleScrollView *cycleScrollView7 = [FWCycleScrollView cycleViewWithViewArray:customViewArray2 frame:CGRectMake(0, CGRectGetMaxY(cycleScrollView6.frame) + 20, self.view.frame.size.width, 30)];
    cycleScrollView7.pageControlType = PageControlTypeNone;
    cycleScrollView7.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView7.autoScrollTimeInterval = 2.0;
    cycleScrollView7.itemDidClickedBlock = ^(NSInteger index){
        NSLog(@"当前点击了第 %ld 个广告位",(index + 1));
    };
    cycleScrollView7.itemDidScrollBlock = ^(NSInteger index){
        //        NSLog(@"当前轮播到了第 %ld 个广告位",(index + 1));
    };
    [self.scrollView addSubview:cycleScrollView7];
    
    
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(cycleScrollView7.frame) + 20);
}

- (UILabel *)setupUIView:(int)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    label.text = [NSString stringWithFormat:@"第 %d 张自定义视图", (index + 1)];
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:(float)(1+arc4random()%99)/100 green:(float)(1+arc4random()%99)/100 blue:(float)(1+arc4random()%99)/100 alpha:1];
    return label;
}

- (UILabel *)setupUIView2:(int)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    label.text = [NSString stringWithFormat:@"第 %d 张自定义视图", (index + 1)];
    label.textColor = UIColor.whiteColor;
    label.backgroundColor = [UIColor lightGrayColor];
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
