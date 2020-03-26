//
//  CAReFundsViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//  奖励提现

import UIKit

class CAReFundsViewController: BaseViewController {

    @IBOutlet weak var refundsAccountOutlet: UILabel!
    @IBOutlet weak var blanceOutlet: UILabel!
    @IBOutlet weak var refundsAmountOutlet: UITextField!
    @IBOutlet weak var submitOutlet: UIButton!
    
    @IBOutlet weak var remindOutlet: UILabel!
    private var viewModel: CAReFundsViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        let submitSignal = submitOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in
                self.view.endEditing(true)
            })
        viewModel = CAReFundsViewModel.init(reRundsDriver: refundsAmountOutlet.rx.text.orEmpty.asDriver(),
                                            submitDriver: submitSignal)
        
        viewModel.drawInfoObser.asDriver()
            .drive(onNext: { [weak self] in
                self?.refundsAccountOutlet.text = $0.Alipay
                self?.blanceOutlet.text = "\($0.UserFunds)"
                self?.remindOutlet.text = "最低提现额度：\($0.MinWithdwaw)元 服务费率: \($0.Poundage)"
            })
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
}
