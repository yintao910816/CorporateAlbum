//
//  CAAccountViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAAccountViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    private var headerView: CAAccountHeaderView!
    
    private var userModel: UserInfoModel!
    
    private var viewModel: CAAccountViewModel!
    
    override func setupUI() {
        headerView = CAAccountHeaderView.init(frame: .init(x: 0, y: 0, width: view.width, height: CAAccountHeaderView.viewHeight))
        headerView.model = userModel
        tableView.tableHeaderView = headerView
        
        headerView.selectedCallBack = { [unowned self] in
            if $0.0 == .avatar {
                NoticesCenter.alertActions(messages: ["拍照", "相册"], cancleTitle: "取消") { idx in
                    if idx == 0 {
                        // 拍照
                        self.invokeSystemCamera()
                    }else if idx == 1 {
                        // 相册
                        self.invokeSystemPhoto()
                    }
                }
            }else {
                self.performSegue(withIdentifier: $0.1, sender: $0.2)
            }
        }
    }
    
    override func rxBind() {
        viewModel = CAAccountViewModel.init()
    }
    
    override func prepare(parameters: [String : Any]?) {
        userModel = (parameters!["model"] as! UserInfoModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.prepare(parameters: sender! as? [String: Any])
    }
}

extension CAAccountViewController {
    
    override func reloadViewWithImg(img: UIImage) {
        headerView.reloadAvatar(img)
        viewModel.submitAvatarSetSubject.onNext(img)
    }
    
    override func reloadViewWithCameraImg(img: UIImage) {
        headerView.reloadAvatar(img)
        viewModel.submitAvatarSetSubject.onNext(img)
    }
}
