//
//  CAMineViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import RxDataSources

// 账号设置
private let accountSetSegue = "accountSetSegue"
// 收益明细
private let billSegue = "billSegue"
// 我的消息
private let mynoticeSegue = "mynoticeSegue"
// 我的画册站点
private let myalbumSegue  = "myalbumSegue"
// 修改头像
private let avatarSetSegue = "avatarSetSegue"

class CAMineViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    
    private let viewModel = MineViewModel()
    
    private var headerView: MineHeaderView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.reloadSubject.onNext(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        headerView = MineHeaderView.init(disposebag: disposeBag)
        
        var rect = headerView.contentView.frame
        rect.size.height += LayoutSize.topVirtualArea
        headerView.contentView.frame = rect
        
        tableView.tableHeaderView = headerView.contentView
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func rxBind() {
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cellID", cellType: UITableViewCell.self)) { (row, model, cell) in
                cell.textLabel?.text = model.title
                cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
        
        viewModel.userInfoObser.asDriver()
            .skip(1)
            .drive(headerView.userInfoObser)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver().drive(onNext: { [unowned self] in self.pushVC($0) })
            .disposed(by: disposeBag)
        
        headerView.avatarOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: avatarSetSegue, sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func pushVC(_ indexPath: IndexPath) {
        if indexPath.row == 3 {
            performSegue(withIdentifier: mynoticeSegue, sender: nil)
            return
        }else if indexPath.row == 6 {
            let webVC = WebViewController()
            webVC.htmlURL = APIAssistance.userHelp
            webVC.navigationItem.title = "使用帮助"
            navigationController?.pushViewController(webVC, animated: true)
            return
        }else if indexPath.row == 7 {
            CACoreLogic.clearCookie()

            CACoreLogic.pressentLoginVC()
            return
        }
        if viewModel.userIsLoginObser.value == true {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: accountSetSegue, sender: nil)
                break
            case 1:
                performSegue(withIdentifier: billSegue, sender: nil)
                break
            case 2:
                let webVC = WebViewController()
                webVC.htmlURL = APIAssistance.cash
                webVC.navigationItem.title = "奖励提现"
                navigationController?.pushViewController(webVC, animated: true)
                break
            case 4:
                performSegue(withIdentifier: myalbumSegue, sender: nil)
                break
            case 5:
                let webVC = WebViewController()
                webVC.htmlURL = APIAssistance.openAlbum
                webVC.navigationItem.title = "开通画册"
                navigationController?.pushViewController(webVC, animated: true)
                break
            default:
                break
            }
        }else {
            NoticesCenter.alert(title: "提示", message: "请先登录后操作")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == accountSetSegue {
            let controller = segue.destination as! CAAccountSetTableViewController
            controller.prepare(parameters: ["model": viewModel.userInfoObser.value])
        }else if segue.identifier == avatarSetSegue {
            let controller = segue.destination as! CASetAvatarViewController
            controller.prepare(parameters: ["user": viewModel.userInfoObser.value])
        }
    }

}
