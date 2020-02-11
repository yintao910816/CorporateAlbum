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
    private var footerView: CAOrderListItemFooterView!
    
    /// 从开通画册界面跳转过来需要返回订单列表界面
    public var isPopToOrderList: Bool = false
    
    override func setupUI() {
        headerView = CAOrderListItemHeaderView.init(frame: .init(x: 0, y: 0,
                                                                 width: view.width,
                                                                 height: CAOrderListItemHeaderView.viewHeight))
        tabelView.tableHeaderView = headerView
                
        footerView = CAOrderListItemFooterView.init(frame: .init(x: 0, y: 0,
                                                                 width: view.width,
                                                                 height: CAOrderListItemFooterView.viewHeight))
        if orderInfo.Paid >= orderInfo.Price {
            PrintLog("已付款")
        }else {
            tabelView.tableFooterView = footerView
        }
        
        tabelView.rowHeight = CAOrderListItemCell_height
        tabelView.register(UINib.init(nibName: "CAOrderListItemCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAOrderListItemCell_identifier)
    }
    
    override func rxBind() {
        headerView.model = orderInfo

        viewModel = CAOrderListItemsViewModel.init(orderModel: orderInfo,
                                                   submit: footerView.submitOutlet.rx.tap.asDriver())
        
        tabelView.prepare(viewModel, showFooter: false, showHeader: false)
        
        viewModel.datasource.asDriver()
            .drive(tabelView.rx.items(cellIdentifier: CAOrderListItemCell_identifier, cellType: CAOrderListItemCell.self)){ (row, model, cell) in
                cell.model = model
        }
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(parameters: [String : Any]?) {
        orderInfo = (parameters!["model"] as! CAOrderInfoModel)
        if let isPopToOrderList = parameters!["isPopToOrderList"] as? Bool {
            self.isPopToOrderList = isPopToOrderList
        }
    }
}
