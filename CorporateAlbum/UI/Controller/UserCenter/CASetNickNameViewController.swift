//
//  CASetNickNameViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CASetNickNameViewController: BaseViewController {

    @IBOutlet weak var nicekNameOutlet: UITextField!
    @IBOutlet weak var authorCodeOutlet: UITextField!
    @IBOutlet weak var getAuthorCodeOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var viewModel: SetNickNameViewModel!
    
    override func setupUI() {
        submitOutlet.layer.cornerRadius = 4
        
        for idx in 100 ..< 102 {
            let aview = view.viewWithTag(idx)
            aview?.layer.borderWidth  = 1
            aview?.layer.borderColor  = UIColor.red.cgColor
        }
    }
    
    override func rxBind() {
        
        viewModel = SetNickNameViewModel.init(input: (authorCodeOutlet.rx.text.orEmpty.asDriver(),
                                                      nickName: nicekNameOutlet.rx.text.orEmpty.asDriver()),
                                              tap: (getAuthorCode: getAuthorCodeOutlet.rx.tap.asDriver(),
                                                    submit: submitOutlet.rx.tap.asDriver()))
        
        viewModel.nickNameObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(view.viewWithTag(100)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.authorCodeObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(view.viewWithTag(101)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

}
