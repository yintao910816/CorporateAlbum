//
//  CASetEmailViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CASetEmailViewController: BaseViewController {

    @IBOutlet weak var authorCodeOutlet: UITextField!
    @IBOutlet weak var newEmailOutlet: UITextField!
    @IBOutlet weak var getSmsOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var viewModel: SetEmailViewModel!

    override func setupUI() {
        submitOutlet.layer.cornerRadius = 4
        
        for idx in 100 ..< 102 {
            let aview = view.viewWithTag(idx)
            aview?.layer.borderWidth  = 1
            aview?.layer.borderColor  = UIColor.red.cgColor
        }
    }
    
    override func rxBind() {
        
        viewModel = SetEmailViewModel.init(input: (authorCode:authorCodeOutlet.rx.text.orEmpty.asDriver(),
                                                   newEmail: newEmailOutlet.rx.text.orEmpty.asDriver()),
                                           tap: (getAuthorCode: getSmsOutlet.rx.tap.asDriver(),
                                                 submit: submitOutlet.rx.tap.asDriver()))
        
        viewModel.authorCodeObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(view.viewWithTag(100)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.emailObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(view.viewWithTag(101)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

}
