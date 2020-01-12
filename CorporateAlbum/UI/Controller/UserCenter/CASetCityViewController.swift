//
//  CASetCityViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CASetCityViewController: BaseViewController {

    @IBOutlet weak var cityOutlet: UITextField!
    @IBOutlet weak var locationOutlet: UIButton!
    @IBOutlet weak var saveOutlet: UIButton!
    
    private var userInfo: UserInfoModel!
    
    private var viewModel: CASetCityViewModel!
    
    override func setupUI() {
        cityOutlet.text = userInfo.RegionTitle
    }
    
    override func rxBind() {
        viewModel = CASetCityViewModel.init(userInfo: userInfo,
                                            submit: saveOutlet.rx.tap.asDriver(),
                                            location: locationOutlet.rx.tap.asDriver())
    }
    
    override func prepare(parameters: [String : Any]?) {
        userInfo = (parameters!["model"] as! UserInfoModel)
    }
}
