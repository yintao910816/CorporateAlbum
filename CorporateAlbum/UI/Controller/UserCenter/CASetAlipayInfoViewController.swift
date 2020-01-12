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
    
    override func setupUI() {
        contentView = CASetAlipayInfoContentView.init(frame: .init(x: 0, y: 0,
                                                                   width: view.width,
                                                                   height: CASetAlipayInfoContentView.normalHeight))
        tableView.tableHeaderView = contentView
    }
    
    override func rxBind() {
        
        contentView.clickedCameraCallBack = { [unowned self] in
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
    }
    
}

extension CASetAlipayInfoViewController {
    
    override func reloadViewWithImg(img: UIImage) {
        contentView.reloadIdCardImage(img)
    }
    
    override func reloadViewWithCameraImg(img: UIImage) {
        contentView.reloadIdCardImage(img)
    }
}
