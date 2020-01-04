//
//  CACorporateViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAMyCorporateViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var searchBarHeightCns: NSLayoutConstraint!
    
    var viewModel: CorporateViewModel!
    
    lazy var qrViewFilesOwner: AlbumShareFilesOwner = {
        let owner = AlbumShareFilesOwner.init(show: self.view)
        return owner
    }()
    
    lazy var menuView: MenuListView = {
        let menu = MenuListView.init(width: 100, datasource: ["全部", "收藏"])
        menu.menuChooseObser.asDriver()
            .skip(1)
            .do(onNext: { [unowned self] idx in
//                self.searchBar.changeLeftItemState()
//                self.searchBar.leftItemTitle = idx == 0 ? "全部" : "收藏"
            })
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] row in
                self.viewModel.dataTypeObser.value = row
                self.tableView.headerRefreshing()
            })
            .disposed(by: self.disposeBag)
        return menu
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupUI() {
        view.insertSubview(menuView, belowSubview: searchBar)
        searchBarHeightCns.constant += LayoutSize.topVirtualArea

        tableView.rowHeight = 155
        tableView.register(UINib.init(nibName: "SiteInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")        
    }
    
    override func rxBind() {
        viewModel = CorporateViewModel(searchTextObser: searchBar.searchText)
        
        tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: SiteInfoCell.self)){ (row, model, cell) in
                cell.model = model
                
                cell.delegate = nil
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        searchBar.leftItemTap.drive(onNext: { [unowned self] in
            self.menuView.menuAnimation()
        })
            .disposed(by: disposeBag)
        
        searchBar.rightItemTap.drive(onNext: { [unowned self] in
            let scanCtrl = CAScanViewController()
            self.navigationController?.pushViewController(scanCtrl, animated: true)
        })
            .disposed(by: disposeBag)

        searchBar.searchActionPublic.subscribe(onNext: { [unowned self] _ in
            self.tableView.headerRefreshing()
        })
            .disposed(by: disposeBag)

        tableView.headerRefreshing()
    }
}

extension CAMyCorporateViewController: SiteInfoCellActions {
    
    func share(model: SiteInfoModel) {
        qrViewFilesOwner.show(shareSite: model)
    }
    
    func collecte(model: SiteInfoModel) {
        viewModel.collectePublic.onNext(model)
    }
}
