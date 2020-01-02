//
//  CAMyNoticesViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAMyNoticesViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    
    private var viewModel: MyNoticesViewModel!
    
    override func setupUI() {
        
        tableView.register(UINib.init(nibName: "MyNoticesCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
    }
    
    override func rxBind() {
        viewModel = MyNoticesViewModel()
        
        tableView.prepare(viewModel, NoticeInfoModel.self, true)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: MyNoticesCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(NoticeInfoModel.self)
            .asDriver()
            .do(onNext: { [unowned self] model in
                model.IsNewest = false
                let webVC = WebViewController()
                webVC.navigationItem.title = model.Title
                webVC.htmlURL = model.Link
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            .drive(viewModel.modelSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.tableView.reloadRows(at: [$0], with: .none)
            })
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.headerRefreshing()
    }

}

extension CAMyNoticesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        PrintLog(viewModel.datasource.value[indexPath.row].Summary + "-----"  + "\(indexPath.row)" + "-----" + viewModel.datasource.value[indexPath.row].Title)
        return MyNoticesCell.cellHeight(viewModel.datasource.value[indexPath.row])
    }
}
