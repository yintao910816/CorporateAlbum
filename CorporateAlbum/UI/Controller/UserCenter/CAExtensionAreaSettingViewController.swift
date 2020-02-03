//
//  CAExtensionAreaViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//  推广区域设置

import UIKit

class CAExtensionAreaSettingViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    
    private var siteModel: CAMySiteModel!
    private var listData: [CARegionInfoModel] = []

    private var viewModel: CAExtensionAreaSettingViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 55
        
        tableView.register(UINib.init(nibName: "CAReginCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAReginCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAExtensionAreaSettingViewModel.init(siteModel: siteModel, listData: listData)
        
        viewModel.regionDataource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: CAReginCell_identifier, cellType: CAReginCell.self)) { _, model, cell in
                cell.model = model
                cell.isHiddenDelete = false
        }
        .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(parameters: [String : Any]?) {
        siteModel = (parameters!["site"] as! CAMySiteModel)
        listData = (parameters!["list"] as! [CARegionInfoModel])
    }
}
