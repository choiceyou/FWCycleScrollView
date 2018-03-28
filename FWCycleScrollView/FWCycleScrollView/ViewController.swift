//
//  ViewController.swift
//  FWCycleScrollView
//
//  Created by xfg on 2018/3/28.
//  Copyright © 2018年 xfg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let adArray = ["ad_1", "ad_2", "ad_3"]
    let adArray2 = ["ad_1", "ad_2", "ad_3", "ad_4", "ad_5", "ad_6", "ad_7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        
        let cycleScrollView = FWCycleScrollView.cycleImage(localizationImageNameArray: adArray, frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 180))
        self.view.addSubview(cycleScrollView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

