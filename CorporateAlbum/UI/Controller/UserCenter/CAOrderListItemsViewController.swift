//
//  CAOrderListItemsViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOrderListItemsViewController: BaseViewController {

    private var orderInfo: CAOrderInfoModel!
    private var viewModel: CAOrderListItemsViewModel!
    
    @IBOutlet weak var tabelView: BaseTB!
    private var headerView: CAOrderListItemHeaderView!
    
    override func setupUI() {
        headerView = CAOrderListItemHeaderView.init(frame: .init(x: 0, y: 0,
                                                                 width: view.width,
                                                                 height: CAOrderListItemHeaderView.viewHeight))
        tabelView.tableHeaderView = headerView
        
        headerView.model = orderInfo
        
        tabelView.rowHeight = CAOrderListItemCell_height
        
        tabelView.register(UINib.init(nibName: "CAOrderListItemCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAOrderListItemCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAOrderListItemsViewModel.init(orderModel: orderInfo)
        
        tabelView.prepare(viewModel, showFooter: false, showHeader: false)
        
        viewModel.datasource.asDriver()
            .drive(tabelView.rx.items(cellIdentifier: CAOrderListItemCell_identifier, cellType: CAOrderListItemCell.self)){ (row, model, cell) in
                cell.model = model
        }
            .disposed(by: disposeBag)
        
        
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(parameters: [String : Any]?) {
        orderInfo = (parameters!["model"] as! CAOrderInfoModel)
    }
}
