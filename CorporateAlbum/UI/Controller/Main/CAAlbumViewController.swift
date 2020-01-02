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
    @IBOutlet weak var searchBar: SearchBar!
    
    private var viewModel: AlbumViewModel!
    
    lazy var qrViewFilesOwner: AlbumShareFilesOwner = {
        let owner = AlbumShareFilesOwner.init(show: self.view)
        return owner
    }()
    
    lazy var menuView: MenuListView = {
        let menu = MenuListView.init(width: 100, datasource: ["全部", "收藏"])
        menu.menuChooseObser.asDriver()
            .skip(1)
            .do(onNext: { [unowned self] idx in
                self.searchBar.changeLeftItemState()
                self.searchBar.leftItemTitle = idx == 0 ? "全部" : "收藏"
            })
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] row in
                self.viewModel.dataTypeObser.value = row
                self.collectionView.headerRefreshing()
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
                
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: PPScreenW/2.0, height: AlbumCell.cellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
    }
    
    override func rxBind() {
        viewModel = AlbumViewModel.init(searchTextObser: searchBar.searchText)
        
        collectionView.prepare(viewModel, AlbumBookModel.self, true)
        
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
            self.collectionView.headerRefreshing()
        })
            .disposed(by: disposeBag)
        
        collectionView.headerRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "siteAlbumSegue" {
            let controller = segue.destination as! CASiteAlbumBookViewController
            let book = sender as! AlbumBookModel
            controller.prepare(parameters: ["siteName": book.SiteName, "title": book.SiteTitle])
        }
    }
}

extension CAAlbumViewController: AlbumCellActions {
    
    func share(model: AlbumBookModel) {
        qrViewFilesOwner.show(shareBook: model)
    }
    
    func collecte(model: AlbumBookModel) {
        viewModel.collectePublic.onNext(model)
    }
    
    func goToSiteBooks(model: AlbumBookModel) {
        performSegue(withIdentifier: "siteAlbumSegue", sender: model)
    }
}
