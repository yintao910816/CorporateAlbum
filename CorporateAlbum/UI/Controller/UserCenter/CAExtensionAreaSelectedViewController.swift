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
    
    private var viewModel: CAExtensionAreaSelectedViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 60
        
        tableView.register(UINib.init(nibName: "CAReginCell", bundle: Bundle.main),
                           forCellReuseIdentifier: CAReginCell_identifier)
    }
    
    override func rxBind() {
        viewModel = CAExtensionAreaSelectedViewModel.init()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, CARegionListModel>>.init(configureCell: { _, tb, indexPath, model -> UITableViewCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: CAReginCell_identifier) as! CAReginCell)
            cell.localRegionModel = model
            cell.isHiddenDelete = true
            return cell
        })

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
}

extension CAExtensionAreaSelectedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = RGB(168, 168, 168)
        label.font = .font(fontSize: 15)
        label.text = viewModel.sectionTitles[section]
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    
}
