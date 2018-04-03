//
//  ViewController.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let adArray = ["ad_1", "ad_2", "ad_3"]
    let adArray2 = ["ad_4", "ad_5", "ad_6"]
    let adArray3 = ["ad_5", "ad_6", "ad_7"]
    let adArray4 = ["ad_1", "ad_2", "ad_3", "ad_4", "ad_5", "ad_6", "ad_7"]
    
    let netAdArray = ["http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                      "http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                      "http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                      "http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"]
    
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height * 1.5)
        return scrollView
    }()
    
    /// 例一：简单使用、默认分页控件
    lazy var cycleScrollView1: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleImage(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 180))
        cycleScrollView.localizationImageNameArray = adArray
        return cycleScrollView
    }()
    
    /// 例二：点击广告位回调、纵向滚动、默认分页控件
    lazy var cycleScrollView2: FWCycleScrollView = {
        let cycleScrollView = FWCycleScrollView.cycleImage(imageUrlStrArray: netAdArray, placeholderImage: UIImage(named: "ad_placeholder"), frame: CGRect(x: 0, y: self.cycleScrollView1.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.autoScrollTimeInterval = 2.0
        cycleScrollView.pageControlAliment = .right
        cycleScrollView.pageControlType = .classic
        cycleScrollView.scrollDirection = .vertical
        cycleScrollView.currentPageDotColor = UIColor.red
        cycleScrollView.pageDotColor = UIColor.white
        // cycleScrollView.pageControlDotSize = CGSize(width: 20, height: 10)
        cycleScrollView.pageControlMargin = 15
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    /// 例三：自定义图片分页控件
    lazy var cycleScrollView3: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleImage(localizationImageNameArray: adArray3, frame: CGRect(x: 0, y: self.cycleScrollView2.frame.maxY + 20, width: self.view.frame.width, height: 180))
        cycleScrollView.setupDotImage(pageDotImage: UIImage(named: "pageControlDot")!, currentPageDotImage: UIImage(named: "pageControlCurrentDot")!)
        cycleScrollView.autoScrollTimeInterval = 2.5
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    /// 例四：加载网络图片、自定义空心分页控件
    lazy var cycleScrollView4: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleImage(imageUrlStrArray: netAdArray, placeholderImage: UIImage(named: "ad_placeholder"), frame: CGRect(x: 0, y: self.cycleScrollView3.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.currentPageDotEnlargeTimes = 1.2
        cycleScrollView.customDotViewType = .hollow
        cycleScrollView.pageDotColor = UIColor.white
        cycleScrollView.currentPageDotColor = UIColor.white
        cycleScrollView.pageControlDotSize = CGSize(width: 10, height: 10)
        cycleScrollView.autoScrollTimeInterval = 2.0
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    /// 例五：自定义实心分页控件
    lazy var cycleScrollView5: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleImage(localizationImageNameArray: adArray4, frame: CGRect(x: 0, y: self.cycleScrollView4.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.currentPageDotEnlargeTimes = 1.0
        cycleScrollView.customDotViewType = .solid
        cycleScrollView.pageDotColor = UIColor.lightGray
        cycleScrollView.currentPageDotColor = UIColor.yellow
        cycleScrollView.pageControlDotSize = CGSize(width: 12, height: 12)
        cycleScrollView.autoScrollTimeInterval = 2.0
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    lazy var cycleScrollView6: FWCycleScrollView = {
        
        let customViewArray = [self.setupUIView(index: 0),
                               self.setupUIView(index: 1),
                               self.setupUIView(index: 2),
                               self.setupUIView(index: 3),
                               self.setupUIView(index: 4)]
        
        let cycleScrollView = FWCycleScrollView.cycleView(viewArray: customViewArray, frame:  CGRect(x: 0, y: self.cycleScrollView5.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.currentPageDotEnlargeTimes = 1.0
        cycleScrollView.customDotViewType = .hollow
        cycleScrollView.pageDotColor = UIColor.red
        cycleScrollView.currentPageDotColor = UIColor.red
        cycleScrollView.pageControlDotSize = CGSize(width: 12, height: 12)
        cycleScrollView.autoScrollTimeInterval = 2.0
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.cycleScrollView1)
        self.scrollView.addSubview(self.cycleScrollView2)
        self.scrollView.addSubview(self.cycleScrollView3)
        self.scrollView.addSubview(self.cycleScrollView4)
        self.scrollView.addSubview(self.cycleScrollView5)
        self.scrollView.addSubview(self.cycleScrollView6)
    }
    
    func setupUIView(index: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
        label.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        label.textColor = UIColor.white
        label.text = "第 \(index + 1) 张自定义视图"
        label.textAlignment = .center
        return label
    }
}

