//
//  FWUIImageViewCell.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit

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
    
    func setupUI(imageName: String?, imageUrl: String?) {
        
        if imageName != nil {
            self.imageView.image = UIImage(named: imageName!)
        } else {
            
        }
    }
}
