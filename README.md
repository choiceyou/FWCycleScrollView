IOS之轮播控件 -- OC/Swift4.0  
===================================  

### 支持pod导入：

pod 'FWCycleScrollView'<br>
注意：如出现 Unable to find a specification for 'FWCycleScrollView' 错误，可执行 pod repo update 命令。

-----------------------------------

### 简单使用（注：可下载demo具体查看，分别有OC、Swift的demo）：  

```python
/// 类初始化方法
///
/// - Parameter frame: FWCycleScrollView的大小
/// - Returns: self
@objc open class func cycleImage(frame: CGRect) -> FWCycleScrollView
```

### OC：
```python

```


### Swift: <br>
```python
let netAdArray = ["http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                          "http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                          "http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                          "http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"]
        
let cycleScrollView = FWCycleScrollView.cycleImage(imageUrlStrArray: netAdArray,
                                                           placeholderImage: UIImage(named: "ad_placeholder"),
                                                           frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))                                                             
```

-----------------------------------  

### 效果：

![]()

-----------------------------------

### 注意点：

一、本UI库是用Swift4.0编写的，所以安装或者拖入文件后需要把对应的Swift设置为4.0版本： <br>
（1）pod安装方式：![](https://github.com/choiceyou/FWSegmentedControl/blob/master/%E8%AE%BE%E7%BD%AE1.jpg)
（2）文件拖入方式：Targets --> Build Setting 做相同的设置

二、关于OC、Swift混编等相关问题，网上有很多相关解答，我这边就不再重复了

-----------------------------------

### 结尾语：

> * 使用过程中有任何问题或者新的需求都可以issues我哦；
> * 欢迎关注本人更多的UI库，谢谢；

