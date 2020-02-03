
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
    private var viewModel: CAMySiteSettingViewModel!
    
    private var headerView: CAMySiteSettingHeaderView!
    private var footerView: CAMySiteSettingFooterView!
    
    override func setupUI() {
        headerView = CAMySiteSettingHeaderView.init(frame: .init(x: 0, y: 0,
                                                                 width: view.width,
                                                                 height: CAMySiteSettingHeaderView.viewHeight))
        footerView = CAMySiteSettingFooterView.init(frame: .init(x: 0, y: 0,
                                                                 width: view.width,
                                                                 height: 60))

        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.rowHeight = 45
        
        tableView.register(UINib.init(nibName: "CAReginCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAReginCell_identifier)
    }

    override func rxBind() {
        headerView.model = siteModel

        headerView.actonCallBack = { [unowned self] in
            self.performSegue(withIdentifier: $0.segue, sender: $0)
        }
        
        viewModel = CAMySiteSettingViewModel.init(input: siteModel)
        
        viewModel.regionDataource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: CAReginCell_identifier, cellType: CAReginCell.self)) { _, model, cell in
                cell.model = model
                cell.isHiddenDelete = true
        }
        .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }

    override func prepare(parameters: [String : Any]?) {
        siteModel = (parameters!["model"] as! CAMySiteModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let type = sender as? CASiteSettingType else {
            return
        }
        
        segue.destination.prepare(parameters: viewModel.prepareParams(type: type))
    }
}
