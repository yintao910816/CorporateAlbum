//
//  CALoginViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CALoginViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak internal var phoneOutlet: UITextField!
    
    @IBOutlet weak internal var passOutlet: UITextField!
    
    @IBOutlet weak internal var loginOutlet: UIButton!

    private var viewModel: LoginViewModel!
    
    @IBAction func dismissVC(_ sender: UIButton) {
        userDefault.userType = .tourist
        self.dismiss(animated: true, completion: nil)
    }
    
    override func setupUI() {
        loginOutlet.layer.cornerRadius = 4
        
        for idx in 100 ..< 102 {
            let view = contentView.viewWithTag(idx)
            view?.layer.borderWidth  = 1
            view?.layer.borderColor  = UIColor.red.cgColor
        }
    }
    
    override func rxBind() {
        
        viewModel = LoginViewModel.init(input: (phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                pass: passOutlet.rx.text.orEmpty.asDriver()),
                                        loginDriver: loginOutlet.rx.tap.asDriver())
        
        viewModel.phoneObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(contentView.viewWithTag(100)!.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.passObser.map{ return $0 == true ? UIColor.clear : UIColor.red }
            .asDriver().drive(contentView.viewWithTag(101)!.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

}
