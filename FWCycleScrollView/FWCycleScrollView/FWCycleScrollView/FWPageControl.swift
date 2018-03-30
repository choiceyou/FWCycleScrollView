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
    
}
