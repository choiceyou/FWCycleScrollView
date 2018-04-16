//
//  FWUIImageViewCell.swift
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
import Kingfisher

class FWUIImageViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.imageView.frame = self.bounds
        self.imageView.contentMode = .scaleToFill
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(imageName: String?, imageUrl: String?, placeholderImage: UIImage?) {
        
        if imageName != nil {
            self.imageView.image = UIImage(named: imageName!)
        } else if imageUrl != nil {
            self.imageView.kf.setImage(with: URL(string: imageUrl!), placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}
