//
//  CAMySiteLogViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAMySiteLogViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!

    private var headerView: CAMySiteLogHeaderView!
    
    private var viewModel: CAMySiteLogViewModel!
    private var siteModel: CAMySiteModel!
        
    override func setupUI() {
        tableView.rowHeight = CAMySiteLogCell_height
        
        headerView = CAMySiteLogHeaderView.init(frame: .init(x: 0, y: 0,
                                                             width: view.width,
                                                             height: CAMySiteLogHeaderView.viewHeight))
        tableView.tableHeaderView = headerView
        headerView.model = siteModel
        
        tableView.register(UINib.init(nibName: "CAMySiteLogCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAMySiteLogCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAMySiteLogViewModel.init(siteModel: siteModel)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: CAMySiteLogCell_identifier, cellType: CAMySiteLogCell.self)) { _, model, cell in
                cell.model = model
        }
        .disposed(by: disposeBag)
        
        tableView.prepare(viewModel)
        tableView.headerRefreshing()
    }
    
    override func prepare(parameters: [String : Any]?) {
        siteModel = (parameters!["model"] as! CAMySiteModel)
    }
}
