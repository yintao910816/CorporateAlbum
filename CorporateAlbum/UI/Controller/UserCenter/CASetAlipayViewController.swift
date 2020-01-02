//
//  CASetAlipayViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CASetAlipayViewController: BaseViewController {

    @IBOutlet weak var authorCodeOutlet: UITextField!
    @IBOutlet weak var newAlipayOutlet: UITextField!
    @IBOutlet weak var getAuthorCodeOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var viewModel: SetAlipayViewModel!
    
    override func setupUI() {
        submitOutlet.layer.cornerRadius = 4
        
        for idx in 100 ..< 102 {
            let aview = view.viewWithTag(idx)
            aview?.layer.borderWidth  = 1
            aview?.layer.borderColor  = UIColor.red.cgColor
        }
    }
    
    override func rxBind() {
        
        viewModel = SetAlipayViewModel.init(input: (authorCode:authorCodeOutlet.rx.text.orEmpty.asDriver(),
                                                   newAlipay: newAlipayOutlet.rx.text.orEmpty.asDriver()),
                                           tap: (getAuthorCode: getAuthorCodeOutlet.rx.tap.asDriver(),
                                                 submit: submitOutlet.rx.tap.asDriver()))
        
        viewModel.authorCodeObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(view.viewWithTag(100)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.alipayObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(view.viewWithTag(101)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

}
