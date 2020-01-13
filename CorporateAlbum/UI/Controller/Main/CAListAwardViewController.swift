//
//  CAListAwardViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAListAwardViewController: BaseViewController {

    @IBOutlet weak var searchBarHeightCns: NSLayoutConstraint!
    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var tableView: BaseTB!

    var viewModel: CAListAwardViewModel!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        searchBarHeightCns.constant += LayoutSize.topVirtualArea_1
                
        searchBar.tfSearchIcon = "tf_search"
        searchBar.rightItemIcon = "nav_qr_scan"
        searchBar.searchPlaceholder = "搜奖励"
        searchBar.backgroundColor = CA_MAIN_COLOR
        searchBar.tfBgColor = .white
        searchBar.coverButtonEnable = false
        searchBar.returnKeyType = .search
        
        tableView.rowHeight = 90
        tableView.register(UINib.init(nibName: "BillCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
    
    override func rxBind() {

        viewModel = CAListAwardViewModel(searchTextObser: searchBar.textObser)

        tableView.prepare(viewModel)

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: BillCell.self)){ (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver()
            .drive(viewModel.itemSelected)
            .disposed(by: disposeBag)

        searchBar.rightItemTapBack = { [unowned self] in
            let scanCtrl = CAScanViewController()
            self.navigationController?.pushViewController(scanCtrl, animated: true)
        }

        searchBar.beginSearch = { [unowned self] _ in
            self.viewModel.beginSearchSubject.onNext(Void())
        }

        tableView.headerRefreshing()
    }

}
