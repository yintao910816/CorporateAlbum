//
//  CASetPhoneViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CASetPhoneViewController: BaseViewController {

    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var codeOutlet: UITextField!
    @IBOutlet weak var getAuthorCodeOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var viewModel: SetPhoneViewModel!
    private var userInfo: UserInfoModel!

    override func setupUI() {
        phoneOutlet.text = userInfo.Mobile
        
        getAuthorCodeOutlet.layer.borderWidth = 1
        getAuthorCodeOutlet.layer.borderColor = RGB(8, 172, 222).cgColor
    }
    
    override func rxBind() {
        
        viewModel = SetPhoneViewModel.init(input: (phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                   code: codeOutlet.rx.text.orEmpty.asDriver(),
                                                   userInfo: userInfo),
                                           tap: (getAuthorCode: getAuthorCodeOutlet.rx.tap.asDriver(),
                                                 submit: submitOutlet.rx.tap.asDriver()))
        
        viewModel.enabelSubject.asObservable()
            .do(onNext: { [weak self] in
                PrintLog("绑定数据：\($0)")
                self?.submitOutlet.backgroundColor = $0 ? RGB(254, 163, 41) : RGB(200, 200, 200)
            })
            .bind(to: submitOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.secondsSubject
            .bind(to: getAuthorCodeOutlet.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.codeEnableSubject.asObservable()
            .bind(to: getAuthorCodeOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
                
        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

    override func prepare(parameters: [String : Any]?) {
        userInfo = (parameters!["model"] as! UserInfoModel)
    }

}
