//
//  CAResetPassViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAResetPassViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var authorCodeOutlet: UITextField!
    @IBOutlet weak var passOutlet: UITextField!
    @IBOutlet weak var repassOutlet: UITextField!
    
    @IBOutlet weak var getAuthorCodeOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var viewModel: ResetPassViewModel!
    
    override func setupUI() {
        
        submitOutlet.layer.cornerRadius = 4
        
        for idx in 100 ..< 104 {
            let view = contentView.viewWithTag(idx)
            view?.layer.borderWidth  = 1
            view?.layer.borderColor  = UIColor.red.cgColor
        }
        
    }
    
    override func rxBind() {
        viewModel = ResetPassViewModel.init(input: (phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                    pass: passOutlet.rx.text.orEmpty.asDriver(),
                                                    repass: repassOutlet.rx.text.orEmpty.asDriver(),
                                                    authorCode: authorCodeOutlet.rx.text.orEmpty.asDriver()),
                                            tap: (authorCode: getAuthorCodeOutlet.rx.tap.asDriver(),
                                                  register: submitOutlet.rx.tap.asDriver()))
    
        viewModel.popSubject.asObserver()
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.phoneObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(contentView.viewWithTag(100)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.authorCodeObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(contentView.viewWithTag(101)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.passObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(contentView.viewWithTag(102)!.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.repassObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(contentView.viewWithTag(103)!.rx.borderColor)
            .disposed(by: disposeBag)
    }

}
