//
//  CAResetMySitePassWordViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/6.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAResetMySitePassWordViewController: BaseViewController {

    @IBOutlet weak var accountOutlet: UILabel!
    @IBOutlet weak var pwdOutlet: UITextField!
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var siteModel: CAMySiteModel!

    private var viewModel: CAResetMySitePassWordViewModel!
    
    override func setupUI() {
        accountOutlet.text = siteModel.ManageUserName
        pwdOutlet.text = siteModel.ManagePassword
    }
    
    override func rxBind() {
        let submitDriver = submitOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in
                self.view.endEditing(true)
            })
        
        viewModel = CAResetMySitePassWordViewModel.init(input: (siteModel: siteModel,
                                                                passDriver: pwdOutlet.rx.text.orEmpty.asDriver()),
                                                        submit: submitDriver)
        
        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.submitEnable
            .drive(submitOutlet.rx.actionEnabled)
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        siteModel = (parameters!["model"] as! CAMySiteModel)
    }
}
