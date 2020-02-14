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
        if CACoreLogic.share.isInCheck {
            rect.size.height = rect.size.height - 70 + LayoutSize.topVirtualArea
        }else {
            rect.size.height += LayoutSize.topVirtualArea
        }
        headerView.contentView.frame = rect
        
        tableView.tableHeaderView = headerView.contentView
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func rxBind() {
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, MineCellModel>>.init(configureCell: { _, tb, indexPath, model -> UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = model.title
            cell.imageView?.image = model.icon
            cell.accessoryType = .disclosureIndicator
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        viewModel.userInfoObser.asDriver()
            .skip(1)
            .drive(headerView.userInfoObser)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MineCellModel.self)
            .asDriver().drive(onNext: { [unowned self] in self.pushVC($0) })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        headerView.avatarTapSubject
            .subscribe(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "accountSegue", sender: ["model":$0])
            })
            .disposed(by: disposeBag)
    }
    
    private func pushVC(_ model: MineCellModel) {
//        if indexPath.row == 3 {
//            performSegue(withIdentifier: mynoticeSegue, sender: nil)
//            return
//        }else if indexPath.row == 6 {
//            let webVC = WebViewController()
//            webVC.htmlURL = APIAssistance.userHelp
//            webVC.navigationItem.title = "使用帮助"
//            navigationController?.pushViewController(webVC, animated: true)
//            return
//        }else if indexPath.row == 7 {
//            CACoreLogic.clearCookie()
//
//            CACoreLogic.pressentLoginVC()
//            return
//        }
        if viewModel.userIsLoginObser.value == true {
            if model.isLoginOut {
                CACoreLogic.pressentLoginVC()
                return
            }
            
            if model.segue.count > 0 {
                performSegue(withIdentifier: model.segue, sender: model.params)
            }else if model.webURL.count > 0 {
                let webVC = WebViewController()
                webVC.htmlURL = model.webURL
                webVC.title = "关于我们"
                navigationController?.pushViewController(webVC, animated: true)
            }else {
                NoticesCenter.alert(message: "开发中，敬请期待...")
            }
//            switch indexPath.row {
//            case 0:
//                performSegue(withIdentifier: accountSetSegue, sender: nil)
//                break
//            case 1:
//                performSegue(withIdentifier: billSegue, sender: nil)
//                break
//            case 2:
//                let webVC = WebViewController()
//                webVC.htmlURL = APIAssistance.cash
//                webVC.navigationItem.title = "奖励提现"
//                navigationController?.pushViewController(webVC, animated: true)
//                break
//            case 4:
//                performSegue(withIdentifier: myalbumSegue, sender: nil)
//                break
//            case 5:
//                let webVC = WebViewController()
//                webVC.htmlURL = APIAssistance.openAlbum
//                webVC.navigationItem.title = "开通画册"
//                navigationController?.pushViewController(webVC, animated: true)
//                break
//            default:
//                break
//            }
        }else {
            NoticesCenter.alert(title: "提示", message: "请先登录后操作")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.prepare(parameters: sender as! [String: Any])
//        if segue.identifier == accountSetSegue {
//            let controller = segue.destination as! CAAccountSetTableViewController
//            controller.prepare(parameters: ["model": viewModel.userInfoObser.value])
//        }else if segue.identifier == avatarSetSegue {
//            let controller = segue.destination as! CASetAvatarViewController
//            controller.prepare(parameters: ["user": viewModel.userInfoObser.value])
//        }
    }

}

extension CAMineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = UIView.init(frame: .init(x: 0, y: 0, width: view.width, height: 10))
            header.backgroundColor = RGB(236, 236, 236)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 10 : 0
    }
}
