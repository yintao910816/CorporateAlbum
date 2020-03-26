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

    /// 是否为下单
    private var functionType: CAOpenAlbumFunctionType = .order
    private var siteInfo: CAMySiteModel?
    
    private var viewModel: CAOpenAlbumViewModel!
    
    override func setupUI() {
        navigationItem.title = functionType == .order ? "我要下单" : "订单续费"
        
        contentHeaderView = CAOpenAlbumHeaderContentView.init(frame: .init(x: 0, y: 0,
                                                               width: view.width,
                                                               height: CAOpenAlbumHeaderContentView.viewHeight))
        
        let footerHeight: CGFloat = functionType == .order ? CAOpenAlbumFooterContentView.viewHeight : CAOpenAlbumFooterContentView.viewShorterHeight
        contentFooterView = CAOpenAlbumFooterContentView.init(frame: .init(x: 0, y: 0,
                                                               width: view.width,
                                                               height: footerHeight))
        contentFooterView.reloadUI(functionType: functionType)
        if functionType != .order {
            contentFooterView.siteInfo = siteInfo
        }

        tabelView.tableHeaderView = contentHeaderView
        tabelView.tableFooterView = contentFooterView
        
        tabelView.rowHeight = CAOrderListItemCell_height
        
        tabelView.register(UINib.init(nibName: "CAOrderListItemCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAOrderListItemCell_identifier)
        
        picker.view.frame = view.bounds
    }
    
    override func rxBind() {
        viewModel = CAOpenAlbumViewModel.init(submit: contentFooterView.submitOutlet.rx.tap.asDriver(),
                                              agreement: contentFooterView.serverAgreementOutlet.rx.tap.asDriver(),
                                              functionType: functionType)
        
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
            .filter{ [unowned self] in self.functionType == .order }
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
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        functionType = parameters!["functionType"] as! CAOpenAlbumFunctionType
        siteInfo = parameters!["siteInfo"] as? CAMySiteModel
    }
}
