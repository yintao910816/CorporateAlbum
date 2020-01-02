//
//  BaseViewController.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/10/28.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGB(242, 242, 242)
        setupUI()
        
        rxBind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fixTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIApplication.shared.statusBarStyle != .lightContent {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        if UIApplication.shared.isStatusBarHidden == true {
            UIApplication.shared.isStatusBarHidden = false
        }

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        ImageCacheCenter.shared.clear()
    }
    
    deinit{
        PrintLog("\(self) 已释放")
    }
}
