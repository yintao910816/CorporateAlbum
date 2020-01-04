//
//  CABillViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CABillViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    private var viewModel: BillViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 90
        tableView.register(UINib.init(nibName: "BillCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
    }
    
    override func rxBind() {
        viewModel = BillViewModel()
        
        tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: BillCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
                
        tableView.headerRefreshing()
    }
}
