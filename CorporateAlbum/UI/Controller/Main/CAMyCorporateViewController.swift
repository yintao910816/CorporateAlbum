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
    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var slideMenu: TYSlideMenuView!
    @IBOutlet weak var searchBarHeightCns: NSLayoutConstraint!
    
    var viewModel: CorporateViewModel!
    
    lazy var qrViewFilesOwner: AlbumShareFilesOwner = {
        let owner = AlbumShareFilesOwner.init(show: self.view)
        return owner
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupUI() {
        searchBarHeightCns.constant += LayoutSize.topVirtualArea
                
        searchBar.tfSearchIcon = "tf_search"
        searchBar.rightItemIcon = "nav_qr_scan"
        searchBar.searchPlaceholder = "企业名称/域名"
        searchBar.backgroundColor = CA_MAIN_COLOR
        searchBar.tfBgColor = .white
        searchBar.coverButtonEnable = false
        searchBar.returnKeyType = .search
        
        slideMenu.datasource = TYListMenuModel.createHomeMenu()

        tableView.rowHeight = 110
        tableView.register(UINib.init(nibName: "SiteInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")        
    }
    
    override func rxBind() {

        viewModel = CorporateViewModel(searchTextObser: searchBar.textObser)
        
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
                
        searchBar.rightItemTapBack = { [unowned self] in
            let scanCtrl = CAScanViewController()
            self.navigationController?.pushViewController(scanCtrl, animated: true)
        }
        
        searchBar.beginSearch = { [unowned self] _ in
            self.viewModel.beginSearchSubject.onNext(Void())
        }

        
        slideMenu.menuSelect = { [unowned self] page in
            self.viewModel.menuChangeSubject.onNext(page)
        }

        viewModel.reloadSubject.onNext(true)
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
