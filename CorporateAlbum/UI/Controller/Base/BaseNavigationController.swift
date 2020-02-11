//
//  BaseNavigationController.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/11/23.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, VMNavigation {
    
    /**
     * 是否开启右滑返回手势
     */
    var isSideBackEnable: Bool! {
        didSet {
            isSideBackEnable == true ? startSideBack() : stopSideBack()
        }
    }
    
    private func startSideBack() {
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func stopSideBack() {
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        
        isSideBackEnable = true
        
        self.navigationBar.barTintColor        =  CA_MAIN_COLOR
        self.navigationBar.isTranslucent       = false
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.white]
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0
        { // 非根控制器
            viewController.hidesBottomBarWhenPushed = true
            
            let backButton : UIButton = UIButton(type : .system)
            backButton.setImage(UIImage(named :"navigationButtonReturn")?.withRenderingMode(.alwaysOriginal), for: .normal)
            backButton.addTarget(self, action :#selector(backAction), for: .touchUpInside)
            backButton.sizeToFit()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButton)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK
    //MARK: action
    @objc func backAction() {
        if let remindVC = viewControllers.last as? CAScanRemindViewController {
            remindVC.navigationController?.popToRootViewController(animated: true)
            return
        }
                
        if let siteAlbumBookVC = viewControllers.last as? CASiteAlbumBookViewController {
            if userDefault.isPopToRoot == true {
                siteAlbumBookVC.navigationController?.popToRootViewController(animated: true)
                userDefault.isPopToRoot = false
                return
            }
        }

        if let orderInfoVC = viewControllers.last as? CAOrderListItemsViewController, orderInfoVC.isPopToOrderList == true {
            popToRootViewController(animated: false)
            BaseNavigationController.sbPush("Main", "orderListViewCtrl")
            return
        }
        
        if let webVC = viewControllers.last as? WebViewController,
            webVC.webView != nil && webVC.webView.canGoBack == true {
            if userDefault.isPopToRoot == true {
                webVC.navigationController?.popToRootViewController(animated: true)
                userDefault.isPopToRoot = false
                return
            }
            webVC.webView.goBack()
            return
        }
                
        popViewController(animated: true)
    }
    
    deinit {
        PrintLog("\(self) 已释放")
    }

}

extension BaseNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (viewControllers.count > 1 && isSideBackEnable)
    }
}
