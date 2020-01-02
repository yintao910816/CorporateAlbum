//
//  CAAccountSetTableViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAAccountSetTableViewController: BaseTableViewController {

    private var viewModel: AccountSetViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel != nil {
            viewModel.reloadSubject.onNext(true)
        }
    }
    
    override func setupUI() {
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()

        tableView.register(AccountSetCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func rxBind() {
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: AccountSetCell.self)) { (row, model, cell) in
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = model.title
                cell.detailTextLabel?.text = model.detailTitle
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] in self.pushVC($0) })
            .disposed(by: disposeBag)
    }
    
    private func pushVC(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "setNickNameSegue", sender: nil)
            break
        case 1:
            performSegue(withIdentifier: "setPhoneSegue", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "setEmailSegue", sender: nil)
            break
        case 3:
            performSegue(withIdentifier: "setAlipaySegue", sender: nil)
            break
        default:
            break
        }
    }
    
    override func prepare(parameters: [String : Any]?) {
        viewModel = AccountSetViewModel.init(userInfo: parameters!["model"] as! UserInfoModel)
    }

}
