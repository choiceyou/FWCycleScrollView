//
//  FWCustomDotView.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/30.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit

/// 自定义分页控件类型，默认为hollow
///
/// - hollow: 空心
/// - solid: 实心
/// - image: 图片
@objc public enum FWCustomDotViewType: Int {
    case hollow
    case solid
    case image
}

class FWCustomDotView: UIView {
    
    /// 选中分页控件的颜色
    public var currentPageDotColor = UIColor.white
    /// 未选中分页控件的颜色
    public var pageDotColor = UIColor.lightGray
    /// 自定义分页控件类型
    public var customDotViewType: FWCustomDotViewType?
    
    /// 未选中分页控件：图片方式
    public var pageDotImage: UIImageView?
    /// 选中分页控件：图片方式
    public var currentPageDotImage: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if self.customDotViewType == .image {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            self.backgroundColor = self.currentPageDotColor
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
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
                
            }
            
            self.transform = CGAffineTransform.identity
        }) { (finished) in
            
        }
    }
}
