//
//  BaseNavagationController.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/10/28.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

class MainNavagationController: BaseNavigationController {
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if topViewController!.isKind(of: SRPersonViewController.self) == true{
//            let rightButton : UIButton = UIButton(type : .system)
//            // 设置
//            rightButton.setImage(UIImage(named:"mine_setting")?.withRenderingMode(.alwaysOriginal), for: .normal)
//            rightButton.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
//
//            rightButton.sizeToFit()
//            topViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightButton)
//
//        }
    }
    
//    @objc func settingAction() {
//        let settingVC = SRSettingViewController.init(nibName: "SRSettingViewController", bundle: Bundle.main)
//        pushViewController(settingVC, animated: true)
//    }
    
}
