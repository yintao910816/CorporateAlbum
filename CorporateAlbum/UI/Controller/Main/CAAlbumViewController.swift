//
//  CAAlbumViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAAlbumViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBarHeightCns: NSLayoutConstraint!
    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var slideMenu: TYSlideMenuView!
    
    private var viewModel: AlbumViewModel!
    
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
        searchBar.searchPlaceholder = "画册名称/域名"
        searchBar.backgroundColor = CA_MAIN_COLOR
        searchBar.tfBgColor = .white
        searchBar.coverButtonEnable = false
        searchBar.returnKeyType = .search
        
        slideMenu.datasource = TYListMenuModel.createHomeMenu()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: PPScreenW/2.0, height: AlbumCell.cellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
    }
    
    override func rxBind() {
        
        viewModel = AlbumViewModel.init()
        
        collectionView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "cell", cellType: AlbumCell.self)) { (row, model, cell) in
                cell.model = model
                cell.delegate = nil
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(AlbumBookModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bookInfoID") as! CAAlbumInfoViewController
                controller.prepare(parameters: ["bookId": model.Id])
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        searchBar.beginSearch = { [unowned self] _ in
            self.viewModel.beginSearchSubject.onNext(Void())
        }

        searchBar.textObser
            .bind(to: viewModel.searchTextObser)
            .disposed(by: disposeBag)
        
        searchBar.rightItemTapBack = { [unowned self] in
            let scanCtrl = CAScanViewController()
            self.navigationController?.pushViewController(scanCtrl, animated: true)
        }
        
        slideMenu.menuSelect = { [unowned self] page in
            self.viewModel.menuChangeSubject.onNext(page)
        }
                
        collectionView.headerRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "siteAlbumSegue" {
            let controller = segue.destination as! CASiteAlbumBookViewController
            let book = sender as! AlbumBookModel
            controller.prepare(parameters: ["siteName": book.SiteName, "title": book.Title])
        }else if segue.identifier == "shareAlbumSegue" {
            segue.destination.prepare(parameters: ["model": sender!])
        }
    }
}

extension CAAlbumViewController: AlbumCellActions {
    
    func share(model: AlbumBookModel) {
//        qrViewFilesOwner.show(shareBook: model)
        performSegue(withIdentifier: "shareAlbumSegue", sender: model)
    }
    
    func collecte(model: AlbumBookModel) {
        viewModel.collectePublic.onNext(model)
    }
    
    func goToSiteBooks(model: AlbumBookModel) {
        performSegue(withIdentifier: "siteAlbumSegue", sender: model)
    }
}
