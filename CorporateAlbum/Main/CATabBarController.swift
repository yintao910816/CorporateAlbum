//
//  SRTabBarController.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/10/28.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

class CATabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        delegate = self
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: CA_MAIN_COLOR], for:.selected)

        setValue(FixTabBar(), forKey: "tabBar")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
