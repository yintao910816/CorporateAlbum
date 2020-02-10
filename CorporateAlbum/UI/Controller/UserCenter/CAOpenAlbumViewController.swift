//
//  CAOpenAlbumViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOpenAlbumViewController: BaseViewController {

    @IBOutlet weak var tabelView: BaseTB!
    
    private var contentHeaderView: CAOpenAlbumHeaderContentView!
    private var contentFooterView: CAOpenAlbumFooterContentView!

    private var viewModel: CAOpenAlbumViewModel!
    
    override func setupUI() {
        contentHeaderView = CAOpenAlbumHeaderContentView.init(frame: .init(x: 0, y: 0,
                                                               width: view.width,
                                                               height: CAOpenAlbumHeaderContentView.viewHeight))
        contentFooterView = CAOpenAlbumFooterContentView.init(frame: .init(x: 0, y: 0,
                                                               width: view.width,
                                                               height: CAOpenAlbumFooterContentView.viewHeight))

        tabelView.tableHeaderView = contentHeaderView
        tabelView.tableFooterView = contentFooterView
        
        tabelView.rowHeight = CAOrderListItemCell_height
        
        tabelView.register(UINib.init(nibName: "CAOrderListItemCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAOrderListItemCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAOpenAlbumViewModel.init()
        
        viewModel.orderListDatasource.asDriver()
            .drive(tabelView.rx.items(cellIdentifier: CAOrderListItemCell_identifier, cellType: CAOrderListItemCell.self)){ (row, model, cell) in
                cell.model = model
                cell.quantityEnable = true
        }
        .disposed(by: disposeBag)
        
        contentFooterView.arrowOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                if self.viewModel.pickerSource.count > 0 {
                    let picker = TYPickerView.init()
                    picker.view.frame = self.view.bounds
                    picker.datasource = self.viewModel.pickerSource
                    self.addChildViewController(picker)
                    
                    picker.finishSelected = {
                        if $0.0 == .ok {
                            self.contentFooterView.companyOutlet.text = $0.1[0]?.contentAttribute.string
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        contentFooterView.serverAgreementOutlet.rx.tap.asDriver()
            .drive(viewModel.serverAgreementSubject)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
}
