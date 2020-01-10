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
    @IBOutlet weak var submitOutlet: UIButton!
    
    private var userInfo: UserInfoModel!
    
    private var viewModel: SetNickNameViewModel!
    
    override func setupUI() {
        nicekNameOutlet.text = userInfo.NickName
    }
    
    override func rxBind() {
        
        viewModel = SetNickNameViewModel.init(nickName: nicekNameOutlet.rx.text.orEmpty.asDriver(),
                                              submit: submitOutlet.rx.tap.asDriver(),
                                              userInfoModel: userInfo)
                
        viewModel.popSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

    override func prepare(parameters: [String : Any]?) {
        userInfo = (parameters!["model"] as! UserInfoModel)
    }
}
