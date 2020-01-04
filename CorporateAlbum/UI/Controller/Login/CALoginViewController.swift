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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {

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
        
        viewModel.loginSubmitDriver
            .drive(loginOutlet.rx.actionEnabled)
            .disposed(by: disposeBag)
    }

}
