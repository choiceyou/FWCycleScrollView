//
//  FWCustomDotView.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/30.
//  Copyright © 2018年 xfg. All rights reserved.
//


/** ************************************************
 
 github地址：https://github.com/choiceyou/FWCycleScrollView
 bug反馈、交流群：670698309
 
 ***************************************************
 */


import Foundation
import UIKit

class FWCustomDotView: UIView {
    
    /// 选中分页控件的颜色
    public var currentPageDotColor = UIColor.white
    /// 未选中分页控件的颜色
    public var pageDotColor = UIColor.lightGray
    /// 自定义分页控件类型
    public var customDotViewType: FWCustomDotViewType?
    
    /// 未选中分页控件：图片方式
    public var pageDotImage: UIImage?
    /// 选中分页控件：图片方式
    public var currentPageDotImage: UIImage?
    /// 分页控件：图片方式
    public lazy var pageDotImageView: UIImageView? = {
        
        let pageDotImageView = UIImageView()
        self.addSubview(pageDotImageView)
        return pageDotImageView
    }()
    
    /// 自定义分页控件，选中分页控件放大的倍数
    public var currentPageDotEnlargeTimes: CGFloat = 1.4
    
    override var frame: CGRect {
        didSet {
            if self.customDotViewType == nil || self.customDotViewType == .hollow {
                self.backgroundColor = UIColor.clear
                self.layer.cornerRadius = frame.width / 2
                self.layer.borderColor = self.pageDotColor.cgColor
                self.layer.borderWidth = 2
            } else if self.customDotViewType == .solid {
                self.backgroundColor = self.pageDotColor
                self.layer.cornerRadius = frame.width / 2
                self.layer.borderWidth = 0
            } else if self.customDotViewType == .image {
                self.layer.borderWidth = 0
                self.pageDotImageView?.frame = self.bounds
                self.pageDotImageView?.image = self.pageDotImage
            }
        }
    }
    
    @objc public func changeActivityState(active: Bool) {
    
        if active {
            self.animateToActiveState()
        } else {
            self.animateToDeactiveState()
        }
    }
    
    public func animateToActiveState() {
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20, options: .curveLinear, animations: {
            
            if self.customDotViewType == nil || self.customDotViewType == .hollow {
                self.backgroundColor = self.currentPageDotColor
            } else if self.customDotViewType == .solid {
                self.backgroundColor = self.currentPageDotColor
            } else if self.customDotViewType == .image {
                self.pageDotImageView?.image = self.currentPageDotImage
            }
            self.transform = CGAffineTransform(scaleX: self.currentPageDotEnlargeTimes, y: self.currentPageDotEnlargeTimes)
            
        }) { (finished) in
            
        }
    }
    
    public func animateToDeactiveState() {
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: {
            
            if self.customDotViewType == nil || self.customDotViewType == .hollow {
                self.backgroundColor = UIColor.clear
            } else if self.customDotViewType == .solid {
                self.backgroundColor = self.pageDotColor
            } else if self.customDotViewType == .image {
                self.pageDotImageView?.image = self.pageDotImage
            }
            self.transform = CGAffineTransform.identity
            
        }) { (finished) in
            
        }
    }
}
