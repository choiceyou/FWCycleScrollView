//
//  FWPageControl.swift
//  FWCycleScrollView
//
//  Created by 叶子 on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//


/** ************************************************
 
 github地址：https://github.com/choiceyou/FWCycleScrollView
 bug反馈、交流群：670698309
 
 ***************************************************
 */


import Foundation
import UIKit

class FWPageControl: UIControl {
    
    /// 选中分页控件的颜色
    public var currentPageDotColor = UIColor.white
    /// 未选中分页控件的颜色
    public var pageDotColor = UIColor.lightGray
    /// 分页控件小圆标大小
    public var pageControlDotSize: CGSize = CGSize(width: 10, height: 10)
    /// 页数
    public var numberOfPages: Int = 0
    /// 分页控件间的间距
    public var spacingBetweenDots: CGFloat = 8
    /// 只有一项的时候隐藏分页控件
    public var hidesForSinglePage: Bool = true
    /// 当前页码
    public var currentPage: Int = 0 {
        willSet {
            if newValue != currentPage {
                self.changeActivity(active: false, index: currentPage)
                self.changeActivity(active: true, index: newValue)
            }
        }
    }
    /// 自定义分页控件类型
    public var customDotViewType: FWCustomDotViewType?
    
    /// 未选中分页控件：图片方式
    public var pageDotImage: UIImage?
    /// 选中分页控件：图片方式
    public var currentPageDotImage: UIImage?
    
    /// 自定义分页控件，选中分页控件放大的倍数
    public var currentPageDotEnlargeTimes: CGFloat = 0.0
    
    private var dotViewArray: [FWCustomDotView] = []
    
    override var frame: CGRect {
        didSet {
            self.setupUI()
            self.resetDotViews()
        }
    }
}

extension FWPageControl {
    
    private func setupUI() {
        
    }
}

extension FWPageControl {
    
    private func resetDotViews() {
        for dotView in self.dotViewArray {
            dotView.removeFromSuperview()
        }
        self.dotViewArray.removeAll()
        self.updateDots()
    }
    
    private func updateDots() {
        if self.numberOfPages == 0 {
            return
        }
        
        for index in 0..<self.numberOfPages {
            var customDotView: FWCustomDotView?
            if index < self.dotViewArray.count {
                customDotView = self.dotViewArray[index]
            } else {
                customDotView = self.generateDotView()
            }
            self.updateDotFrame(dotView: customDotView!, index: index)
        }
        
        self.changeActivity(active: true, index: self.currentPage)
        self.hideForSinglePage()
    }
    
    private func generateDotView() -> FWCustomDotView {
        
        let customDotView = FWCustomDotView()
        customDotView.isUserInteractionEnabled = true
        customDotView.pageDotColor = self.pageDotColor
        customDotView.currentPageDotColor = self.currentPageDotColor
        customDotView.customDotViewType = self.customDotViewType
        if self.pageDotImage != nil {
            customDotView.pageDotImage = pageDotImage
        }
        if self.currentPageDotImage != nil {
            customDotView.currentPageDotImage = currentPageDotImage
        }
        if self.currentPageDotEnlargeTimes > 0 {
            customDotView.currentPageDotEnlargeTimes = self.currentPageDotEnlargeTimes
        }
        self.addSubview(customDotView)
        self.dotViewArray.append(customDotView)
        return customDotView
    }
    
    private func updateDotFrame(dotView: FWCustomDotView, index: Int) {
        
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0
        if self.customDotViewType == .image && self.pageDotImage != nil {
            w = self.pageDotImage!.size.width
            h = self.pageDotImage!.size.height
        } else {
            w = self.pageControlDotSize.width
            h = self.pageControlDotSize.height
        }
        
        let x = w * CGFloat(index) + self.spacingBetweenDots * CGFloat(index)
        let y = (self.frame.height - self.pageControlDotSize.height) / 2
        
        dotView.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    private func changeActivity(active: Bool, index: Int) {
        
        let customDotView: FWCustomDotView = self.dotViewArray[index]
        customDotView.changeActivityState(active: active)
    }
    
    private func hideForSinglePage() {
        if self.dotViewArray.count == 1 && self.hidesForSinglePage {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
    }
}
