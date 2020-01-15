//
//  CAMyAlbumViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/31.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAMyAlbumViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!

    private var viewModel: MyAlbumViewModel!
    
    override func setupUI() {
     
        tableView.rowHeight = 125
        
        tableView.register(UINib.init(nibName: "MyalbumCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
    }
    
    override func rxBind() {
        viewModel = MyAlbumViewModel.init()
        
        tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: MyalbumCell.self)){ [weak self] (row, model, cell) in
                cell.model = model
                cell.siteSettingCallBack = {
                    self?.performSegue(withIdentifier: "mySiteSettingSegue", sender: ["model": $0])
                }
                cell.siteLogCallBack = {
                    self?.performSegue(withIdentifier: "mySiteLogSegue", sender: ["model": $0])
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let param = sender as? [String: Any] else {
            return
        }
        segue.destination.prepare(parameters: param)
    }
}

//extension CAMyAlbumViewController: SiteOperations {
//    func rewardSetting(model: SiteInfoModel) {
//        viewModel.enableAwardSubject.onNext(model)
//    }
//
//    func statusSetting(model: SiteInfoModel) {
//        viewModel.siteStateSubject.onNext(model)
//    }
//
//    func resetReward(model: SiteInfoModel) {
//        viewModel.resetAwardSubject.onNext(model)
//    }
//
//    func recharge(model: SiteInfoModel) {
//        let webVC = WebViewController()
//        webVC.htmlURL = "\(APIAssistance.recharge)=\(model.SiteName)"
//        webVC.navigationItem.title = "充值"
//        navigationController?.pushViewController(webVC, animated: true)
//    }
//
//
//}
