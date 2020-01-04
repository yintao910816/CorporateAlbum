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
    
    private var timer: CountdownTimer!

    override func setupUI() {
        timer = CountdownTimer.init(totleCount: 60)

        getAuthorCodeOutlet.layer.cornerRadius = 5
        getAuthorCodeOutlet.layer.borderWidth = 1
        getAuthorCodeOutlet.layer.borderColor = RGB(8, 172, 222).cgColor
    }
    
    override func rxBind() {
        let submitDriver = submitOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
        let sendCodeDriver = getAuthorCodeOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })

        viewModel = ResetPassViewModel.init(input: (phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                    pass: passOutlet.rx.text.orEmpty.asDriver(),
                                                    repass: repassOutlet.rx.text.orEmpty.asDriver(),
                                                    authorCode: authorCodeOutlet.rx.text.orEmpty.asDriver()),
                                            tap: (authorCode: sendCodeDriver,
                                                  register: submitDriver))
    
        viewModel.popSubject.asObserver()
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.codeSendComplenmentSubject
            .subscribe(onNext: { [weak self] in
                if $0 == true {
                    self?.timer.timerStar()
                }
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
        
        viewModel.codeEnable.asDriver()
            .drive(getAuthorCodeOutlet.rx.enabled)
            .disposed(by: disposeBag)
        
        viewModel.submitEnableObser
            .drive(submitOutlet.rx.actionEnabled)
            .disposed(by: disposeBag)

        timer.showText.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] second in
                if second == 0 {
                    self?.viewModel.codeEnable.value = true
                    self?.getAuthorCodeOutlet.setTitle("获取验证码", for: .normal)
                }else {
                    self?.getAuthorCodeOutlet.setTitle("\(second)s", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }

}
