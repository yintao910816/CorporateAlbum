
//
//  CAMySiteSettingViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAMySiteSettingViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    
    private var siteModel: CAMySiteModel!
    
    private var headerView: CAMySiteSettingHeaderView!
    
    override func setupUI() {
        headerView = CAMySiteSettingHeaderView.init(frame: .init(x: 0, y: 0,
                                                                 width: view.width,
                                                                 height: CAMySiteSettingHeaderView.viewHeight))
        tableView.tableHeaderView = headerView
        headerView.model = siteModel
    }

    override func rxBind() {
        
    }

    override func prepare(parameters: [String : Any]?) {
        siteModel = (parameters!["model"] as! CAMySiteModel)
    }
}
