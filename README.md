# IOS之轮播控件 -- OC/Swift4.0  

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](http://cocoapods.org/?q=FWCycleScrollView)&nbsp;
![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat)&nbsp;
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/choiceyou/FWCycleScrollView/blob/master/FWCycleScrollView/LICENSE)



## 支持pod导入：

```cocoaPods
pod 'FWCycleScrollView'
注意：如出现 Unable to find a specification for 'FWCycleScrollView' 错误，可执行 pod repo update 命令。
```



## 可设置参数：
```参数
/// 本地图片
@objc public var localizationImageNameArray: [String]?
/// 网络图片
@objc public var imageUrlStrArray: [String]?
/// 预加载图片
@objc public var placeholderImage: UIImage?
/// 自定义UI等
@objc public var viewArray: [UIView]?

/// 是否自动轮播
@objc public var autoScroll = true
/// 自动轮播间隔时间
@objc public var autoScrollTimeInterval: TimeInterval = 5.0

/// 轮播图滚动方向
@objc public var scrollDirection: UICollectionViewScrollDirection = .horizontal
/// 轮播轮回次数（1个轮回指的是1组UI轮播完成）
@objc public var loopTimes = 100
/// 选中分页控件的颜色
@objc public var currentPageDotColor = UIColor.white
/// 未选中分页控件的颜色
@objc public var pageDotColor = UIColor.lightGray
/// 分页控件类型
@objc public var pageControlType: PageControlType = .classic
/// 自定义分页控件类型
@objc public var customDotViewType: FWCustomDotViewType = .hollow
/// 分页控件位置
@objc public var pageControlAliment: PageControlAliment = .center
/// 分页控件Insets值
@objc public var pageControlInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
/// 分页控件默认距离的边距
@objc public var pageControlMargin: CGFloat = 10

/// 分页控件大小，注意：当PageControlType不等于自定义类型时，只能影响当前分页控件的大小，不能影响分页控件原点的大小
@objc public var pageControlDotSize: CGSize = CGSize(width: 10, height: 10)
/// 自定义分页控件，选中分页控件放大的倍数
@objc public var currentPageDotEnlargeTimes: CGFloat = 0.0

/// 某一项滚动回调
@objc public var itemDidScrollBlock: ItemDidScrollBlock?
/// 某一项点击回调
@objc public var itemDidClickedBlock: ItemDidClickedBlock?
```


## 简单使用：（注：可下载demo具体查看，分别有OC、Swift的demo）

```swift
/// 类初始化方法
///
/// - Parameter frame: FWCycleScrollView的大小
/// - Returns: self
@objc open class func cycleImage(frame: CGRect) -> FWCycleScrollView
```

### OC：
```oc
NSArray *netAdArray = @[@"http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                        @"http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                        @"http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                        @"http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"];
[FWCycleScrollView cycleImageWithImageUrlStrArray: netAdArray
                                 placeholderImage: [UIImage imageNamed:@"ad_placeholder"]
                                            frame: CGRectMake(0, 0, self.view.frame.size.width, 100)];
```


## Swift: <br>
```swift
let netAdArray = ["http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                  "http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                  "http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                  "http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"]
FWCycleScrollView.cycleImage(imageUrlStrArray: netAdArray,
                             placeholderImage: UIImage(named: "ad_placeholder"),
                                        frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
```



## 效果：

![](https://github.com/choiceyou/FWCycleScrollView/blob/master/%E6%95%88%E6%9E%9C/%E6%95%88%E6%9E%9C1.gif)
![](https://github.com/choiceyou/FWCycleScrollView/blob/master/%E6%95%88%E6%9E%9C/%E6%95%88%E6%9E%9C2.gif)



## 结尾语：

> * 使用过程中有任何问题或者新的需求都可以issues我哦；
> * 欢迎关注本人更多的UI库，谢谢；

