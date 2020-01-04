//
//  CASiteInfoViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CASiteAlbumBookViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var qrViewFilesOwner: AlbumShareFilesOwner = {
        let owner = AlbumShareFilesOwner.init(show: self.view)
        return owner
    }()

    private var viewModel: SiteAlbumBookViewModel!
    
    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: PPScreenW/2.0, height: AlbumCell.cellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
    }
    
    override func rxBind() {
        
        collectionView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "cell", cellType: AlbumCell.self)) { (row, model, cell) in
                cell.model = model
                cell.siteLogoIsHidden = true
                
                cell.delegate = nil
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(AlbumBookModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "albumPageSegue", sender: model)
            })
            .disposed(by: disposeBag)
        
        viewModel.navTitleObser.asDriver()
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        collectionView.headerRefreshing()
    }
    
    override func prepare(parameters: [String : Any]?) {
        let siteName = parameters!["siteName"] as! String
        let navTitle = parameters!["title"] as? String
        viewModel = SiteAlbumBookViewModel.init(siteName: siteName)
        title = navTitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumPageSegue" {
            let controller = segue.destination as! CAAlbumInfoViewController
            let book = sender as! AlbumBookModel
            controller.prepare(parameters: ["bookId": book.Id])
        }
    }

}

extension CASiteAlbumBookViewController: AlbumCellActions {
    
    func goToSiteBooks(model: AlbumBookModel) {
    }
    
    func share(model: AlbumBookModel) {
        qrViewFilesOwner.show(shareBook: model)
    }
    
    func collecte(model: AlbumBookModel) {
        viewModel.collectePublic.onNext(model)
    }
}
