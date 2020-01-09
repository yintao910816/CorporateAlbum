//
//  CAShareCorporateViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/9.
//  Copyright © 2020 yintao. All rights reserved.
//  分享企业

import UIKit

class CAShareCorporateViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var corporateModel: SiteInfoModel!
    
    private var header: CAShareCorporateContentView!
    
    override func setupUI() {
        header = CAShareCorporateContentView.init(frame: view.bounds)
        header.corporateModel = corporateModel
        let headerHeight = header.viewHeight
        header.frame = .init(x: 0, y: 0, width: view.width, height: headerHeight)
        
        tableView.tableHeaderView = header
        
    }
    
    override func rxBind() {
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        corporateModel = (parameters!["model"] as! SiteInfoModel)
    }
}
