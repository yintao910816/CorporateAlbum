//
//  MenuListView.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/3.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import RxSwift

class MenuListView: UITableView {
    
    let menuChooseObser = Variable(0)
    
    private var datasource: [String]!
    private var origlY: CGFloat = 0
    
    init(width: CGFloat, datasource: [String]) {
        let acHeight: CGFloat = 40.0 * CGFloat(datasource.count)
        super.init(frame: .init(x: 0, y: 64 + LayoutSize.topVirtualArea - acHeight, width: width, height: acHeight), style: .plain)
        
        origlY = y
        self.datasource = datasource
        
        rowHeight = 40
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func menuAnimation() {
        if y == origlY {
            showMenu()
        }else {
            hiddenMenu()
        }
    }
    
    private func showMenu() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.y = 64 + LayoutSize.topVirtualArea
        }
    }
    
    private func hiddenMenu() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.y = self.origlY
        }
    }
}

extension MenuListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID")!
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        menuChooseObser.value = (indexPath.row)
        
        hiddenMenu()
    }
}
