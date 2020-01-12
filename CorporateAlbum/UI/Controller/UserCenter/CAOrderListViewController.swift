//
//  CAOrderListViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOrderListViewController: BaseViewController {

    @IBOutlet weak var tabelView: BaseTB!
    
    private var contentView: CAOpenAlbumContentView!
    
    private var viewModel: CAOrderListViewModel!
    
    override func setupUI() {
        tabelView.rowHeight = CAOrderListCell_height
        
        tabelView.register(UINib.init(nibName: "CAOrderListCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAOrderListCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAOrderListViewModel.init()
        
        tabelView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(tabelView.rx.items(cellIdentifier: CAOrderListCell_identifier, cellType: CAOrderListCell.self)){ [weak self] (row, model, cell) in

        }
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
    
}
