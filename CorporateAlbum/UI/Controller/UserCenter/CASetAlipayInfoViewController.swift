//
//  CASetAlipayInfoViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CASetAlipayInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    private var contentView: CASetAlipayInfoContentView!
    
    private var viewModel: CASetAlipayInfoViewModel!
    
    override func setupUI() {
        contentView = CASetAlipayInfoContentView.init(frame: .init(x: 0, y: 0,
                                                                   width: view.width,
                                                                   height: CASetAlipayInfoContentView.normalHeight))
        tableView.tableHeaderView = contentView
    }
    
    override func rxBind() {
        
        contentView.clickedCameraCallBack = { [unowned self] in
            self.view.endEditing(true)
            NoticesCenter.alertActions(messages: ["拍照", "相册"], cancleTitle: "取消") { idx in
                if idx == 0 {
                    // 拍照
                    self.invokeSystemCamera()
                }else if idx == 1 {
                    // 相册
                    self.invokeSystemPhoto()
                }
            }
        }
        
        let getAuthorCodeSignal = contentView.getCodeOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
        let submitSignal = contentView.saveOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
        viewModel = CASetAlipayInfoViewModel.init(input: (code: contentView.codeOutlet.rx.text.orEmpty.asDriver(),
                                                          alipayAccount: contentView.alipayOutlet.rx.text.orEmpty.asDriver(),
                                                          idCard: contentView.idCardOutlet.rx.text.orEmpty.asDriver(),
                                                          alipayName: contentView.alipayNameOutlet.rx.text.orEmpty.asDriver()),
                                                  tap: (getAuthorCode: getAuthorCodeSignal,
                                                        submit: submitSignal))
        
        viewModel.secondsSubject.asObserver()
            .bind(to: contentView.getCodeOutlet.rx.title())
            .disposed(by: disposeBag)
        viewModel.codeEnableSubject.asDriver()
            .drive(contentView.getCodeOutlet.rx.enabled)
            .disposed(by: disposeBag)

    }
    
}

extension CASetAlipayInfoViewController {
    
    override func reloadViewWithImg(img: UIImage) {
        viewModel.idCardImage = img
        contentView.reloadIdCardImage(img)
        tableView.tableHeaderView = nil
        tableView.tableHeaderView = contentView
    }
    
    override func reloadViewWithCameraImg(img: UIImage) {
        viewModel.idCardImage = img
        contentView.reloadIdCardImage(img)
        tableView.tableHeaderView = nil
        tableView.tableHeaderView = contentView
    }
}
