//
//  BaseCollectionViewController.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/9.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewController: UICollectionViewController {
   
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.dataSource = nil
        collectionView?.backgroundColor = UIColor.white

        if #available(iOS 11, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }

//        automaticallyAdjustsScrollViewInsets = true
//
//        extendedLayoutIncludesOpaqueBars = false
//        
//        edgesForExtendedLayout = .all
        
        setupUI()
        
        rxBind()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fixTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

//        ImageCacheCenter.shared.clear()
    }

    deinit{
        PrintLog("\(self) 已释放")
    }
}
