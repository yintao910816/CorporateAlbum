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
    
    private let picker = TYPickerView.init()

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
        
        picker.view.frame = view.bounds
    }
    
    override func rxBind() {
        viewModel = CAOpenAlbumViewModel.init(submit: contentFooterView.submitOutlet.rx.tap.asDriver(),
                                              agreement: contentFooterView.serverAgreementOutlet.rx.tap.asDriver())
        
        viewModel.orderListDatasource.asDriver()
            .drive(tabelView.rx.items(cellIdentifier: CAOrderListItemCell_identifier, cellType: CAOrderListItemCell.self)){  [weak self] (row, model, cell) in
                cell.model = model
                cell.quantityEnable = true
                cell.didEndEditCallBack = {
                    self?.viewModel.reCalculatTotlePriceSubject.onNext($0)
                }
        }
        .disposed(by: disposeBag)
        
        viewModel.totlePriceObser.asDriver()
            .drive(contentFooterView.totlePriceOutlet.rx.text)
            .disposed(by: disposeBag)
        
        contentFooterView.hostOutlet.rx.text.orEmpty
            .asDriver()
            .drive(viewModel.hostObser)
            .disposed(by: disposeBag)
                
        contentFooterView.arrowOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.addChildViewController(self.picker)
            })
            .disposed(by: disposeBag)
                
        contentFooterView.serverAgreementOutlet.rx.tap.asDriver()
            .drive(viewModel.serverAgreementSubject)
            .disposed(by: disposeBag)
        
        viewModel.companyListsDatasource.asDriver()
            .map{ $0 as [[TYPickerDatasource]] }
            .drive(picker.datasourceSignal)
            .disposed(by: disposeBag)
        
        picker.finishSelectedSubject
            .map{ $0[0] as! CACompanyListModel }
            .bind(to: viewModel.companyObser)
            .disposed(by: disposeBag)
        
        picker.finishSelectedSubject
            .map{ $0[0]?.contentAttribute.string ?? "" }
            .bind(to: contentFooterView.companyOutlet.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
}
