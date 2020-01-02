//
//  ViewControllerServer.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/14.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

@objc protocol viewServer {
 
    @objc optional func setupUI()
    
    @objc optional func rxBind()
}

extension UIViewController: viewServer {

    func setupUI() { }
    
    func rxBind() { }
    
    func fixTabBar() {
        if UIDevice.current.isX == true {
            if var frame = tabBarController?.tabBar.frame {
                if frame.size.height != 83 {
                    frame.size.height = 83
                    frame.origin.y    = PPScreenH - 83
                    tabBarController?.tabBar.frame = frame
                }
            }
        }
    }
}
