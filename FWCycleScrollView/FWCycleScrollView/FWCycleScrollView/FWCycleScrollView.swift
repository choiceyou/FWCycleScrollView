//
//  FWCycleScrollView.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//


/** ************************************************
 
 github地址：https://github.com/choiceyou/FWCycleScrollView
 bug反馈、交流群：670698309
 
 ***************************************************
 */


import Foundation
import UIKit

let kImageViewCellId = "imageViewCellId"
let kViewCellId = "viewCellId"

/// 分页控件类型，默认为classic
///
/// - none: 无page
/// - classic: 系统自带经典样式
/// - custom: 自定义类型
@objc public enum PageControlType: Int {
    case none
    case classic
    case custom
}

/// 自定义分页控件类型（即：self.pageControlType == .custom），默认为hollow
///
/// - hollow: 空心
/// - solid: 实心
/// - image: 图片
@objc public enum FWCustomDotViewType: Int {
    case hollow
    case solid
    case image
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
    
    /// 外部传入的本地图片
    @objc public var localizationImageNameArray: [String]? {
        didSet {
            if localizationImageNameArray != nil {
                self.collectionView.register(FWUIImageViewCell.self, forCellWithReuseIdentifier: kImageViewCellId)
                self.sourceArray = localizationImageNameArray as [AnyObject]?
            }
        }
    }
    /// 外部传入的网络图片URL
    @objc public var imageUrlStrArray: [String]? {
        didSet {
            if imageUrlStrArray != nil {
                self.collectionView.register(FWUIImageViewCell.self, forCellWithReuseIdentifier: kImageViewCellId)
                self.sourceArray = imageUrlStrArray as [AnyObject]?
            }
        }
    }
    /// 网络图片预加载图片
    @objc public var placeholderImage: UIImage?
    /// 外部传入的自定义UI
    @objc public var viewArray: [UIView]? {
        didSet {
            if viewArray != nil {
                self.collectionView.register(FWUIviewCell.self, forCellWithReuseIdentifier: kViewCellId)
                self.sourceArray = viewArray as [AnyObject]?
            }
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
    private var pageControl: UIControl?
    /// 轮播轮回次数，注意：当loopTimes>1时，是无限循环轮播的（1个轮回指的是1组UI轮播完成）
    private var loopTimes = 100
    /// 轮播图滚动方向
    @objc public var scrollDirection: UICollectionViewScrollDirection = .horizontal
    /// 选中分页控件的颜色
    @objc public var currentPageDotColor = UIColor.white {
        didSet {
            self.setupPageControl()
        }
    }
    /// 未选中分页控件的颜色
    @objc public var pageDotColor = UIColor.lightGray {
        didSet {
            self.setupPageControl()
        }
    }
    /// 分页控件类型
    @objc public var pageControlType: PageControlType = .classic {
        didSet {
            self.setupPageControl()
        }
    }
    /// 自定义分页控件类型
    @objc public var customDotViewType: FWCustomDotViewType = .hollow {
        didSet {
            self.pageControlType = .custom
        }
    }
    /// 分页控件位置
    @objc public var pageControlAliment: PageControlAliment = .center
    /// 分页控件Insets值
    @objc public var pageControlInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    /// 分页控件默认距离的边距
    @objc public var pageControlMargin: CGFloat = 10
    
    /// 分页控件大小，注意：当PageControlType不等于自定义类型时，只能影响当前分页控件的大小，不能影响分页控件原点的大小
    @objc public var pageControlDotSize: CGSize = CGSize(width: 10, height: 10) {
        didSet {
            self.setupPageControl()
        }
    }
    /// 自定义分页控件，选中分页控件放大的倍数
    @objc public var currentPageDotEnlargeTimes: CGFloat = 0.0 {
        didSet {
            self.setupPageControl()
        }
    }
    
    /// 某一项滚动回调
    @objc public var itemDidScrollBlock: ItemDidScrollBlock?
    /// 某一项点击回调
    @objc public var itemDidClickedBlock: ItemDidClickedBlock?
    
    
    /// 传入的资源
    private var sourceArray: [AnyObject]? {
        didSet {
            if sourceArray != nil && sourceArray!.count > 0 {
                self.collectionView.reloadData()
                self.setupPageControl()
                self.invalidateTimer()
                if autoScroll {
                    self.setupTimer()
                }
                self.layoutIfNeeded()
            }
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
    
    /// 未选中分页控件：图片方式
    private var pageDotImage: UIImage?
    /// 选中分页控件：图片方式
    private var currentPageDotImage: UIImage?
    
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
            if self.collectionView.numberOfItems(inSection: 0) == self.totalItemsCount && self.loopTimes > 1 {
                self.startScrollToItem(targetIndex: targetIndex, animated: true)
            }
        }
        
        if self.pageControl != nil {
            var pSize = CGSize(width: 0, height: 0)
            if self.pageControl!.isKind(of: UIPageControl.self) {
                pSize = CGSize(width: CGFloat(self.sourceCount) * self.pageControlDotSize.width, height: self.pageControlDotSize.height)
            } else if self.pageControl!.isKind(of: FWPageControl.self) {
                var tmpW: CGFloat = 0.0
                var tmpH: CGFloat = 0.0
                if self.customDotViewType == .image && self.pageDotImage != nil {
                    tmpW = CGFloat(self.sourceCount) * self.pageDotImage!.size.width + ((self.pageControl as! FWPageControl).spacingBetweenDots * CGFloat((self.sourceCount - 1)))
                    tmpH = self.pageDotImage!.size.height
                } else {
                    tmpW = CGFloat(self.sourceCount) * self.pageControlDotSize.width + ((self.pageControl as! FWPageControl).spacingBetweenDots * CGFloat((self.sourceCount - 1)))
                    tmpH = self.pageControlDotSize.height
                }
                pSize = CGSize(width: tmpW, height: tmpH)
            }
            var pX: CGFloat = 0
            if self.pageControlAliment == .center {
                pX = (self.frame.width - pSize.width) / 2
            } else if self.pageControlAliment == .left {
                pX = pageControlMargin + 10
            } else if self.pageControlAliment == .right {
                pX = self.frame.width - pSize.width - (pageControlMargin + 10)
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
    @objc open class func cycle(frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, placeholderImage: nil, viewArray: nil)
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameter frame: FWCycleScrollView的大小
    /// - Parameter loopTimes: 轮播轮回次数，注意：当loopTimes>1时，是无限循环轮播的（1个轮回指的是1组UI轮播完成）
    /// - Returns: self
    @objc open class func cycle(frame: CGRect, loopTimes: Int) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, placeholderImage: nil, viewArray: nil)
        cycleScrollView.loopTimes = loopTimes
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
        cycleScrollView.setupUI(localizationImageNameArray: localizationImageNameArray, imageUrlStrArray: nil, placeholderImage: nil, viewArray: nil)
        return cycleScrollView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - imageUrlStrArray: 网络图片URL地址
    ///   - placeholderImage: 预加载图片
    ///   - frame: FWCycleScrollView的大小
    /// - Returns: self
    @objc open class func cycleImage(imageUrlStrArray: [String]?, placeholderImage: UIImage?, frame: CGRect) -> FWCycleScrollView {
        
        let cycleScrollView = FWCycleScrollView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: imageUrlStrArray, placeholderImage: placeholderImage, viewArray: nil)
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
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, placeholderImage: nil, viewArray: viewArray)
        return cycleScrollView
    }
    
    private func setupUI(localizationImageNameArray: [String]?, imageUrlStrArray: [String]?, placeholderImage: UIImage?, viewArray: [UIView]?) {
        self.localizationImageNameArray = localizationImageNameArray
        self.imageUrlStrArray = imageUrlStrArray
        self.placeholderImage = placeholderImage
        self.viewArray = viewArray
    }
    
    /// 设置自定义分页控件类型的图片类型，注意：当设置了该图片后即表明：self.pageControlType = .custom && self.customDotViewType = .image
    ///
    /// - Parameters:
    ///   - pageDotImage: 未选中分页控件：图片方式
    ///   - currentPageDotImage: 选中分页控件：图片方式
    @objc public func setupDotImage(pageDotImage: UIImage, currentPageDotImage: UIImage) {
        
        self.pageDotImage = pageDotImage
        self.currentPageDotImage = currentPageDotImage
        self.customDotViewType = .image
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
            cell.setupUI(imageName: (self.localizationImageNameArray != nil) ? self.localizationImageNameArray![(indexPath.row % self.localizationImageNameArray!.count)] : nil, imageUrl: (self.imageUrlStrArray != nil) ? self.imageUrlStrArray![(indexPath.row % self.imageUrlStrArray!.count)] : nil, placeholderImage: self.placeholderImage)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kViewCellId, for: indexPath) as! FWUIviewCell
            cell.addSubview(self.viewArray![(indexPath.row % self.viewArray!.count)])
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
        if self.sourceArray == nil {
            return
        }
        if self.pageControl != nil {
            self.pageControl?.removeFromSuperview()
        }
        switch self.pageControlType {
        case .none:
            self.pageControl = nil
        case .classic:
            let tmpPageControl = UIPageControl()
            tmpPageControl.numberOfPages = self.sourceCount
            tmpPageControl.currentPageIndicatorTintColor = self.currentPageDotColor
            tmpPageControl.pageIndicatorTintColor = self.pageDotColor
            tmpPageControl.isUserInteractionEnabled = false
            tmpPageControl.currentPage = self.pageControlIndex(cellIndex: self.currentIndex())
            self.addSubview(tmpPageControl)
            
            self.pageControl = tmpPageControl
        case .custom:
            let tmpPageControl = FWPageControl()
            tmpPageControl.numberOfPages = self.sourceCount
            tmpPageControl.currentPageDotColor = self.currentPageDotColor
            tmpPageControl.pageControlDotSize = self.pageControlDotSize
            tmpPageControl.pageDotColor = self.pageDotColor
            tmpPageControl.customDotViewType = self.customDotViewType
            if self.pageDotImage != nil {
                tmpPageControl.pageDotImage = pageDotImage
            }
            if self.currentPageDotImage != nil {
                tmpPageControl.currentPageDotImage = currentPageDotImage
            }
            if self.currentPageDotEnlargeTimes > 0 {
                tmpPageControl.currentPageDotEnlargeTimes = self.currentPageDotEnlargeTimes
            }
            self.addSubview(tmpPageControl)
            
            self.pageControl = tmpPageControl
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
                self.startScrollToItem(targetIndex: targetIndex, animated: false)
            }
            return
        }
        self.startScrollToItem(targetIndex: targetIndex, animated: true)
    }
    
    private func startScrollToItem(targetIndex: Int, animated: Bool) {
        if self.scrollDirection == .horizontal {
            self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .right, animated: animated)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .bottom, animated: animated)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.sourceCount == 0 || self.pageControl == nil {
            return
        }
        
        let itemIndex = self.currentIndex()
        let indexOnPageControl = self.pageControlIndex(cellIndex: itemIndex)
        
        if self.pageControl!.isKind(of: UIPageControl.self) {
            (self.pageControl as! UIPageControl).currentPage = indexOnPageControl
        } else {
            (self.pageControl as! FWPageControl).currentPage = indexOnPageControl
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
