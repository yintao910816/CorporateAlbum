//
//  CAExtensionAreaSelectedViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit
import RxDataSources

class CAExtensionAreaSelectedViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var siteModel: CAMySiteModel?
    private var userInfoModel: UserInfoModel?
    
    private var viewModel: CAExtensionAreaSelectedViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 60
        
        tableView.register(UINib.init(nibName: "CAReginCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAReginCell_identifier)
    }
    
    override func rxBind() {
        if let _siteModel = siteModel {
            navigationItem.title = "地区选择"
            viewModel = CAExtensionAreaSelectedViewModel.init(siteModel: _siteModel)
        }else if let _user = userInfoModel {
            navigationItem.title = "更换城市"
            viewModel = CAExtensionAreaSelectedViewModel.init(user: _user)
        }
                
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, CARegionListModel>>.init(configureCell: { _, tb, indexPath, model -> UITableViewCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: CAReginCell_identifier) as! CAReginCell)
            cell.localRegionModel = model
            cell.isHiddenDelete = true
            return cell
        }, titleForHeaderInSection: { (s, section) -> String? in
            return s.sectionModels[section].model
        }, titleForFooterInSection: { (_, _) -> String? in
            return nil
        }, canEditRowAtIndexPath: { (_, _) -> Bool in
            return false
        }, canMoveRowAtIndexPath: { (_, _) -> Bool in
            return false
        }, sectionIndexTitles: { [weak self] (_) -> [String]? in
            return self?.viewModel.sectionTitles
        }) { (s, t, section) -> Int in
            return section
        }

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CARegionListModel.self)
            .bind(to: viewModel.didSelectedSubject)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(parameters: [String : Any]?) {
        if let userInfoModel = parameters!["model"] as? UserInfoModel {
            self.userInfoModel = userInfoModel
        }else if let siteModel = parameters!["model"] as? CAMySiteModel {
            self.siteModel = siteModel
        }
    }
}

extension CAExtensionAreaSelectedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = RGB(237, 237, 237)
        label.textColor = RGB(154, 154, 154)
        label.font = .font(fontSize: 17)
        label.text = "  \(viewModel.sectionTitles[section])"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
