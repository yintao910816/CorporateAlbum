//
//  CAAccountViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAAccountViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    private var headerView: CAAccountHeaderView!
    
    private var userModel: UserInfoModel!
    
    override func setupUI() {
        headerView = CAAccountHeaderView.init(frame: .init(x: 0, y: 0, width: view.width, height: CAAccountHeaderView.viewHeight))
        headerView.model = userModel
        tableView.tableHeaderView = headerView
        
        headerView.selectedCallBack = { [unowned self] in
            self.performSegue(withIdentifier: $0.0, sender: $0.1)
        }
    }
    
    override func rxBind() {
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        userModel = (parameters!["model"] as! UserInfoModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.prepare(parameters: sender! as? [String: Any])
    }
}
