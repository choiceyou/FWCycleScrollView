//
//  FWPageControl.swift
//  FWCycleScrollView
//
//  Created by 叶子 on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//

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
        
        let customDotView = FWCustomDotView(frame: CGRect(x: 0, y: 0, width: self.pageControlDotSize.width, height: self.pageControlDotSize.height))
        customDotView.isUserInteractionEnabled = true
        customDotView.pageDotColor = self.pageDotColor
        customDotView.currentPageDotColor = self.currentPageDotColor
        customDotView.customDotViewType = self.customDotViewType
        self.addSubview(customDotView)
        self.dotViewArray.append(customDotView)
        return customDotView
    }
    
    private func updateDotFrame(dotView: FWCustomDotView, index: Int) {
        
        let x = self.pageControlDotSize.width * CGFloat(index) + self.spacingBetweenDots * CGFloat(index)
        let y = (self.frame.height - self.pageControlDotSize.height) / 2
        
        dotView.frame = CGRect(x: x, y: y, width: self.pageControlDotSize.width, height: self.pageControlDotSize.height)
    }
    
    private func sizeForNumberOfPages(pageCount: Int) -> CGSize {
        return CGSize(width: (self.pageControlDotSize.width + self.spacingBetweenDots) * CGFloat(pageCount) - self.spacingBetweenDots, height: self.pageControlDotSize.height)
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
