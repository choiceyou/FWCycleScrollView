//
//  FWCycleScrollView.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit

let kImageViewCellId = "imageViewCellId"
let kViewCellId = "viewCellId"

/// 分页控件类型
///
/// - none: 无page
/// - classic: 系统自带经典样式
/// - animated: 动画类型
@objc public enum PageControlType: Int {
    case none
    case classic
    case animated
}

/// 分页控件位置
///
/// - center: 中偏下位置
/// - right: 右偏下位置
/// - left: 左偏下位置
@objc public enum PageControlAliment: Int {
    case center
    case right
    case left
}

/// 某一项滚动回调
public typealias ItemDidScrollBlock = (_ currentIndex: Int) -> Void
/// 某一项点击回调
public typealias ItemDidClickedBlock = (_ currentIndex: Int) -> Void


open class FWCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// 本地图片
    @objc public var localizationImageNameArray: [String]? {
        didSet {
            self.collectionView.register(FWUIImageViewCell.self, forCellWithReuseIdentifier: kImageViewCellId)
            self.sourceArray = localizationImageNameArray as [AnyObject]?
        }
    }
    /// 网络图片
    @objc public var imageUrlStrArray: [String]? {
        didSet {
            self.collectionView.register(FWUIImageViewCell.self, forCellWithReuseIdentifier: kImageViewCellId)
            self.sourceArray = imageUrlStrArray as [AnyObject]?
        }
    }
    /// 自定义UI等
    @objc public var viewArray: [UIView]? {
        didSet {
            self.collectionView.register(FWUIviewCell.self, forCellWithReuseIdentifier: kViewCellId)
            self.sourceArray = viewArray as [AnyObject]?
        }
    }
    
    /// 是否自动轮播
    @objc public var autoScroll = true {
        didSet {
            self.invalidateTimer()
            if autoScroll {
                self.setupTimer()
            }
        }
    }
    /// 自动轮播间隔时间
    @objc public var autoScrollTimeInterval: TimeInterval = 5.0 {
        didSet {
            self.invalidateTimer()
            if autoScrollTimeInterval > 0 {
                self.setupTimer()
            }
        }
    }
    
    /// 分页控件
    private var pageControl: UIPageControl?
    /// 轮播图滚动方向
    @objc public var scrollDirection: UICollectionViewScrollDirection = .horizontal
    /// 轮播轮回次数（1个轮回指的是1组UI轮播完成）
    @objc public var loopTimes = 100
    /// 选中分页控件的颜色
    @objc public var currentPageDotColor = UIColor.white
    /// 未选中分页控件的颜色
    @objc public var pageDotColor = UIColor.lightGray
    /// 分页控件类型
    @objc public var pageControlType: PageControlType = .classic {
        didSet {
            self.setupPageControl()
        }
    }
    /// 分页控件位置
    @objc public var pageControlAliment: PageControlAliment = .center
    /// 分页控件小圆标大小
    @objc public var pageControlDotSize: CGSize = CGSize(width: 10, height: 10)
    /// 分页控件Insets值
    @objc public var pageControlInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    /// 分页控件默认距离的边距
    @objc public var pageControlMargin: CGFloat = 10
    
    /// 某一项滚动回调
    @objc public var itemDidScrollBlock: ItemDidScrollBlock?
    /// 某一项点击回调
    @objc public var itemDidClickedBlock: ItemDidClickedBlock?
    
    
    /// 传入的资源
    private var sourceArray: [AnyObject]? {
        didSet {
            self.collectionView.reloadData()
            self.pageControlType = .classic
            self.autoScroll = true
            self.layoutIfNeeded()
        }
    }
    
    /// 传入的资源总数
    private var sourceCount: Int {
        if self.localizationImageNameArray != nil {
            return self.localizationImageNameArray!.count
        } else if self.imageUrlStrArray != nil {
            return self.imageUrlStrArray!.count
        } else if self.viewArray != nil {
            return self.viewArray!.count
        }
        return 0
    }
    
    /// Item总计条数
    private var totalItemsCount: Int {
        return self.sourceCount * self.loopTimes
    }
    
    /// 轮播定时器
    private var rollTimer: Timer?
    
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
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        self.addSubview(collectionView)
        return collectionView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
        self.collectionViewFlowLayout.itemSize = self.frame.size
        self.collectionViewFlowLayout.scrollDirection = self.scrollDirection
        
        if self.collectionView.contentOffset.x == 0 && self.totalItemsCount > 0 {
            var targetIndex = 0
            if self.loopTimes > 0 {
                targetIndex = self.totalItemsCount / 2
            }
            if self.collectionView.numberOfItems(inSection: 0) == self.totalItemsCount {
                self.startScrollToItem(targetIndex: targetIndex)
            }
        }
        
        if self.pageControl != nil {
            var pSize = CGSize(width: 0, height: 0)
            if self.pageControl != nil && self.pageControl!.isKind(of: UIPageControl.self) {
                pSize = CGSize(width: CGFloat(self.sourceCount) * self.pageControlDotSize.width, height: self.pageControlDotSize.height)
            }
            var pX: CGFloat = 0
            if self.pageControlAliment == .center {
                pX = (self.frame.width - pSize.width) / 2
            } else if self.pageControlAliment == .left {
                pX = pageControlMargin * 2
            } else if self.pageControlAliment == .right {
                pX = self.frame.width - pSize.width - pageControlMargin * 2
            }
            let pY = self.frame.height - pSize.height - pageControlMargin
            
            let pageControlFrame = CGRect(x: pX + self.pageControlInsets.left - self.pageControlInsets.right, y: pY + self.pageControlInsets.top - self.pageControlInsets.bottom, width: pSize.width, height: pSize.height)
            self.pageControl!.frame = pageControlFrame
        }
    }
    
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}

// MARK: - 初始化方法
extension FWCycleScrollView {
    
    /// 类初始化方法
    ///
    /// - Parameter frame: FWCycleScrollView的大小
    /// - Returns: self
    @objc open class func cycleImage(frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, viewArray: nil)
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - localizationImageNameArray: 本地图片名称
    ///   - frame: FWCycleScrollView的大小
    /// - Returns: self
    @objc open class func cycleImage(localizationImageNameArray: [String]?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: localizationImageNameArray, imageUrlStrArray: nil, viewArray: nil)
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - imageUrlStrArray: 网络图片URL地址
    ///   - frame: FWCycleScrollView的大小
    /// - Returns: self
    @objc open class func cycleImage(imageUrlStrArray: [String]?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: imageUrlStrArray, viewArray: nil)
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - viewArray: 自定义UI等
    ///   - frame: FWCycleScrollView的大小
    /// - Returns: self
    @objc open class func cycleView(viewArray: [UIView]?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, viewArray: viewArray)
        return cycleScrollView
    }
    
    private func setupUI(localizationImageNameArray: [String]?, imageUrlStrArray: [String]?, viewArray: [UIView]?) {
        self.localizationImageNameArray = localizationImageNameArray
        self.imageUrlStrArray = imageUrlStrArray
        self.viewArray = viewArray
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FWCycleScrollView {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.imageUrlStrArray != nil || self.localizationImageNameArray != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageViewCellId, for: indexPath) as! FWUIImageViewCell
            cell.setupUI(imageName: (self.localizationImageNameArray != nil) ? self.localizationImageNameArray![(indexPath.row % self.localizationImageNameArray!.count)] : nil, imageUrl: (self.imageUrlStrArray != nil) ? self.imageUrlStrArray![(indexPath.row % self.imageUrlStrArray!.count)] : nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kViewCellId, for: indexPath) as! FWUIviewCell
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.itemDidClickedBlock != nil {
            self.itemDidClickedBlock!(indexPath.row % self.sourceCount)
        }
    }
}

// MARK: - 其他
extension FWCycleScrollView {
    
    private func setupPageControl() {
        if self.pageControl != nil {
            self.pageControl?.removeFromSuperview()
        }
        switch self.pageControlType {
        case .none:
            self.pageControl = nil
        case .classic:
            let tmpPageControl = UIPageControl()
            tmpPageControl.numberOfPages = self.sourceCount
            tmpPageControl.currentPageIndicatorTintColor = currentPageDotColor
            tmpPageControl.pageIndicatorTintColor = self.pageDotColor
            tmpPageControl.isUserInteractionEnabled = false
            tmpPageControl.currentPage = self.pageControlIndex(cellIndex: self.currentIndex())
            self.addSubview(tmpPageControl)
            
            self.pageControl = tmpPageControl
        default: break
            
        }
    }
    
    private func pageControlIndex(cellIndex: Int) -> Int {
        if self.sourceCount > 0 {
            return cellIndex % self.sourceCount
        } else {
            return 0
        }
    }
    
    private func currentIndex() -> Int {
        if collectionView.frame.width == 0 || collectionView.frame.height == 0 {
            return 0
        }
        
        var index = 0
        if self.collectionViewFlowLayout.scrollDirection == .horizontal {
            index = Int((self.collectionView.contentOffset.x + self.collectionViewFlowLayout.itemSize.width * 0.5) / self.collectionViewFlowLayout.itemSize.width)
        } else {
            index = Int((self.collectionView.contentOffset.y + self.collectionViewFlowLayout.itemSize.height * 0.5) / self.collectionViewFlowLayout.itemSize.height)
        }
        return max(0, index)
    }
}

// MARK: - 滚动相关
extension FWCycleScrollView {
    
    public func setupTimer() {
        
        self.invalidateTimer()
        
        if self.autoScroll {
            self.rollTimer = Timer.scheduledTimer(timeInterval: self.autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            RunLoop.main.add(self.rollTimer!, forMode: .commonModes)
        }
    }
    
    public func invalidateTimer() {
        
        if self.rollTimer != nil {
            self.rollTimer?.invalidate()
            self.rollTimer = nil
        }
    }
    
    @objc private func automaticScroll() {
        
        if self.totalItemsCount == 0 {
            return
        }
        
        var targetIndex = self.currentIndex() + 1
        self.scrollToIndex(targetIndex: &targetIndex)
    }
    
    /// 解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    ///
    /// - Parameter newSuperview: 父视图
    open override func willMove(toSuperview newSuperview: UIView?) {
        
        if newSuperview == nil {
            self.invalidateTimer()
        }
    }
    
    /// 手动控制滚动到某一个index
    ///
    /// - Parameter index: 下标
    public func makeScrollViewScrollToIndex(index: Int) {
        
        self.invalidateTimer()
        
        if self.sourceCount == 0 {
            return
        }
        
        var tmpIndex = index + self.totalItemsCount / 2
        self.scrollToIndex(targetIndex: &tmpIndex)
        
        self.setupTimer()
    }
    
    public func scrollToIndex(targetIndex: inout Int) {
        
        if self.collectionView.numberOfItems(inSection: 0) != self.totalItemsCount {
            return
        }
        
        if targetIndex >= self.totalItemsCount {
            if self.loopTimes > 0 {
                targetIndex = self.totalItemsCount / 2
                self.startScrollToItem(targetIndex: targetIndex)
            }
            return
        }
        self.startScrollToItem(targetIndex: targetIndex)
    }
    
    private func startScrollToItem(targetIndex: Int) {
        if self.scrollDirection == .horizontal {
            self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .right, animated: true)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .bottom, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.sourceCount == 0 || self.pageControl == nil {
            return
        }
        
        let itemIndex = self.currentIndex()
        let indexOnPageControl = self.pageControlIndex(cellIndex: itemIndex)
        
        if self.pageControl!.isKind(of: UIPageControl.self) {
            self.pageControl!.currentPage = indexOnPageControl
        } else {
            
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.setupTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.collectionView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if self.sourceCount == 0 || self.pageControl == nil {
            return
        }
        
        let itemIndex = self.currentIndex()
        let indexOnPageControl = self.pageControlIndex(cellIndex: itemIndex)
        
        if self.itemDidScrollBlock != nil {
            self.itemDidScrollBlock!(indexOnPageControl)
        }
    }
}
