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
    
    private var siteModel: CAMySiteModel!
    private var viewModel: CAExtensionAreaSelectedViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 60
        
        tableView.register(UINib.init(nibName: "CAReginCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAReginCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAExtensionAreaSelectedViewModel.init(siteModel: siteModel)
                
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
            .bind(to: viewModel.addSubject)
            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(parameters: [String : Any]?) {
        siteModel = (parameters!["model"] as! CAMySiteModel)
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
