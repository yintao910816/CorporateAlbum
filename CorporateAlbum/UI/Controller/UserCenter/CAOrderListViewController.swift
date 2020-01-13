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
            .drive(tabelView.rx.items(cellIdentifier: CAOrderListCell_identifier, cellType: CAOrderListCell.self)){ (row, model, cell) in
                cell.model = model
        }
            .disposed(by: disposeBag)
        
        tabelView.rx.modelSelected(CAOrderInfoModel.self)
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: "orderInfoSegue", sender: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.prepare(parameters: ["model": sender!])
    }
}
