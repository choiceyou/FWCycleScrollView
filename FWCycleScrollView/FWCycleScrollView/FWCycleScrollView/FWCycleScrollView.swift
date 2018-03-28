//
//  FWCycleScrollView.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit

let imageViewCellId = "imageViewCellId"
let viewCellId = "viewCellId"


open class FWCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// 本地图片
    @objc public var localizationImageNameArray: [String]? {
        willSet {
            self.collectionView.register(FWUIImageViewCell.self, forCellWithReuseIdentifier: imageViewCellId)
        }
    }
    /// 网络图片
    @objc public var imageUrlStrArray: [String]? {
        willSet {
            self.collectionView.register(FWUIImageViewCell.self, forCellWithReuseIdentifier: imageViewCellId)
        }
    }
    /// 自定义UI等
    @objc public var viewArray: [UIView]? {
        willSet {
            self.collectionView.register(FWUIviewCell.self, forCellWithReuseIdentifier: viewCellId)
        }
    }
    
    /// 轮播图滚动方向
    @objc public var scrollDirection: UICollectionViewScrollDirection = .horizontal
    /// 轮播次数
    @objc public var loopTimes = 100
    
    
    /// Item总计条数
    private var totalItemsCount: Int {
        if self.localizationImageNameArray != nil {
            return self.localizationImageNameArray!.count * self.loopTimes
        } else if self.imageUrlStrArray != nil {
            return self.imageUrlStrArray!.count * self.loopTimes
        } else if self.viewArray != nil {
            return self.viewArray!.count * self.loopTimes
        }
        return 0
    }
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0
        return collectionViewFlowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = UIColor.yellow
        collectionView.bounces = false
        self.addSubview(collectionView)
        return collectionView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
        self.collectionViewFlowLayout.itemSize = self.frame.size
        self.collectionViewFlowLayout.scrollDirection = self.scrollDirection
    }
}

extension FWCycleScrollView {
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - localizationImageNameArray: 本地图片名称
    ///   - frame: frame
    /// - Returns: self
    @objc open class func cycleImage(localizationImageNameArray: [String]?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.localizationImageNameArray = localizationImageNameArray
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - imageUrlStrArray: 网络图片URL地址
    ///   - frame: frame
    /// - Returns: self
    @objc open class func cycleImage(imageUrlStrArray: [String]?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.imageUrlStrArray = imageUrlStrArray
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - viewArray: 自定义UI等
    ///   - frame: frame
    /// - Returns: self
    @objc open class func cycleView(viewArray: [UIView]?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.viewArray = viewArray
        return cycleScrollView
    }
}

extension FWCycleScrollView {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.imageUrlStrArray != nil || self.localizationImageNameArray != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageViewCellId, for: indexPath) as! FWUIImageViewCell
            cell.setupUI(imageName: (self.localizationImageNameArray != nil) ? self.localizationImageNameArray![(indexPath.row % self.localizationImageNameArray!.count)] : nil, imageUrl: (self.imageUrlStrArray != nil) ? self.imageUrlStrArray![(indexPath.row % self.imageUrlStrArray!.count)] : nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewCellId, for: indexPath) as! FWUIviewCell
            
            return cell
        }
    }
}
