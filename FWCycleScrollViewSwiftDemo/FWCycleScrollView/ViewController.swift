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
    let adArray4 = ["ad_1", "ad_2"]
    
    let netAdArray = ["http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                      "http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                      "http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                      "http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"]
    
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    /// 例一：简单使用、默认分页控件
    lazy var cycleScrollView1: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycle(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 180))
        cycleScrollView.localizationImageNameArray = adArray
        return cycleScrollView
    }()
    
    /// 例二：点击广告位回调、纵向滚动、自定义分页控件
    lazy var cycleScrollView2: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleAll(frame: CGRect(x: 0, y: self.cycleScrollView1.frame.maxY + 20, width: self.view.frame.width, height: 140), localizationImageNameArray: nil, imageUrlStrArray: netAdArray, placeholderImage: UIImage(named: "ad_placeholder"), viewArray: nil, loopTimes: 100, contentMode: .scaleAspectFit)
        
        cycleScrollView.autoScrollTimeInterval = 2.0
        
        // 对自定义也分控件的设置
        cycleScrollView.pageControlAliment = .right
        cycleScrollView.currentPageDotEnlargeTimes = 1.0
        cycleScrollView.customDotViewType = .solid
        cycleScrollView.pageControlDotSize = CGSize(width: 8, height: 8)
        cycleScrollView.scrollDirection = .vertical
        cycleScrollView.currentPageDotColor = UIColor.red
        cycleScrollView.pageDotColor = UIColor.white
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
    
    /// 例五：默认分页控件
    lazy var cycleScrollView5: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleImage(localizationImageNameArray: adArray4, frame: CGRect(x: 0, y: self.cycleScrollView4.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.pageControlType = .classic
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
    
    
    /**
     自定义视图注意点：
     1、当自定义UI数量 =1 时，UICollectionView的复用机制导致轮播会出现问题，因此此时不支持轮播；
     2、当自定义UI数量 =2 时，UICollectionView的复用机制导致轮播会出现问题，因此此时只支持上下重复轮播；
     3、当自定义UI数量 >2 时，不受限制；
     */
    
    /// 例六：轮播自定义视图 注意：当需要轮播的数据源小于或者等于1
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
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    /// 例七：轮播自定义视图
    lazy var cycleScrollView7: FWCycleScrollView = {
        
        let customViewArray = [self.setupUIView2(index: 0, title: ""),
                               self.setupUIView2(index: 1, title: ""),
                               self.setupUIView2(index: 2, title: ""),
                               self.setupUIView2(index: 3, title: ""),
                               self.setupUIView2(index: 4, title: "")]
        
        let cycleScrollView = FWCycleScrollView.cycleView(viewArray: customViewArray, frame:  CGRect(x: 0, y: self.cycleScrollView6.frame.maxY + 20, width: self.view.frame.width, height: 30))
        cycleScrollView.backgroundColor = UIColor.yellow
        cycleScrollView.pageControlType = .none
        cycleScrollView.scrollDirection = .vertical
        cycleScrollView.autoScrollTimeInterval = 2.0
        cycleScrollView.itemDidClickedBlock = { (index) in
            print("当前点击了第\(index + 1)个广告位")
        }
        cycleScrollView.itemDidScrollBlock = { (index) in
            // print("当前轮播到了第\(index + 1)个广告位")
        }
        return cycleScrollView
    }()
    
    /// 例八：仿直播间礼物列表，viewArray.count > 2 时可循环轮播
    lazy var cycleScrollView8: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycleView(viewArray: self.setupCustomSubView(subViewType: 0), frame: CGRect(x: 0, y: self.cycleScrollView7.frame.maxY + 20, width: self.view.frame.width, height: self.view.frame.width/2 + 30))
        cycleScrollView.currentPageDotEnlargeTimes = 1.0
        cycleScrollView.customDotViewType = .hollow
        cycleScrollView.pageDotColor = UIColor.red
        cycleScrollView.currentPageDotColor = UIColor.red
        cycleScrollView.pageControlDotSize = CGSize(width: 12, height: 12)
        cycleScrollView.autoScroll = false
        return cycleScrollView
    }()
    
    /// 例九：仿产品分类列表，只能单次轮播
    lazy var cycleScrollView9: FWCycleScrollView = {
        
        let cycleScrollView = FWCycleScrollView.cycle(frame: CGRect(x: 0, y: self.cycleScrollView8.frame.maxY + 20, width: self.view.frame.width, height: self.view.frame.width/2 + 30), loopTimes: 1)
        cycleScrollView.currentPageDotEnlargeTimes = 1.0
        cycleScrollView.customDotViewType = .hollow
        cycleScrollView.pageDotColor = UIColor.red
        cycleScrollView.currentPageDotColor = UIColor.red
        cycleScrollView.pageControlDotSize = CGSize(width: 12, height: 12)
        cycleScrollView.autoScroll = false
        return cycleScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.cycleScrollView1)
        self.scrollView.addSubview(self.cycleScrollView2)
        self.scrollView.addSubview(self.cycleScrollView3)
        self.scrollView.addSubview(self.cycleScrollView4)
        self.scrollView.addSubview(self.cycleScrollView5)
        self.scrollView.addSubview(self.cycleScrollView6)
        self.scrollView.addSubview(self.cycleScrollView7)
        self.scrollView.addSubview(self.cycleScrollView8)
        
        // 演示后设置数据
        self.cycleScrollView9.viewArray = self.setupCustomSubView(subViewType: 1)
        self.scrollView.addSubview(self.cycleScrollView9)
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.cycleScrollView9.frame.maxY + 20)
    }
}

extension ViewController {
    
    func setupUIView(index: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
        label.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        label.textColor = UIColor.white
        label.text = "第 \(index + 1) 张自定义视图"
        label.textAlignment = .center
        return label
    }
    
    func setupUIView2(index: Int, title: String) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        if title.isEmpty {
            label.text = "第 \(index + 1) 张自定义视图"
        } else {
            label.text = title
        }
        return label
    }
    
    func setupUIView3(index: Int, frame: CGRect) -> UIView {
        
        let view = UIView(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "gift_\(index%20)"))
        imageView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        view.addSubview(imageView)
        return view
    }
    
    func setupUIView4(index: Int, frame: CGRect) -> UIView {
        
        let view = UIView(frame: frame)
        
        let tmpW = view.frame.width * 0.6
        let tmpH = view.frame.height * 0.6
        
        let label = UILabel(frame: CGRect(x: (view.frame.width - tmpW) / 2, y:  (view.frame.height - tmpH) / 2, width: tmpW, height: tmpH))
        label.frame.size.height = view.frame.height * 0.6
        label.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        label.textColor = UIColor.white
        label.text = "\(index + 1)"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.layer.cornerRadius = label.frame.width / 2
        label.clipsToBounds = true
        view.addSubview(label)
        
        return view
    }
    
    func setupCustomSubView(subViewType: Int) -> [UIView] {
        var tmpX: CGFloat = 0
        var tmpY: CGFloat = 0
        
        let horizontalRow = 4
        let verticalRow = 2
        
        let tmpW = self.view.frame.width / CGFloat(horizontalRow)
        let tmpH = self.view.frame.width / 2 / CGFloat(verticalRow)
        
        var bottomView: UIView?
        
        var customSubViewArray: [UIView] = []
        
        for index in 0...30 {
            
            tmpX = CGFloat(index % horizontalRow) * tmpW
            if (index % (horizontalRow * verticalRow)) < horizontalRow {
                tmpY = 0
            } else {
                tmpY = tmpH
            }
            
            if bottomView == nil || (index % (horizontalRow * verticalRow) == 0) {
                bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width / 2 + 30))
                bottomView?.backgroundColor = UIColor.white
                customSubViewArray.append(bottomView!)
            }
            
            if subViewType == 0 {
                bottomView?.addSubview(self.setupUIView3(index: index, frame: CGRect(x: tmpX, y: tmpY, width: tmpW, height: tmpH)))
            } else {
                bottomView?.addSubview(self.setupUIView4(index: index, frame: CGRect(x: tmpX, y: tmpY, width: tmpW, height: tmpH)))
            }
        }
        
        return customSubViewArray
    }
}

