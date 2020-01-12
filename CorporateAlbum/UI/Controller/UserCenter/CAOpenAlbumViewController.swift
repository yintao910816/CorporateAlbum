//
//  CAOpenAlbumViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOpenAlbumViewController: BaseViewController {

    @IBOutlet weak var tabelView: BaseTB!
    
    private var contentView: CAOpenAlbumContentView!
    
    override func setupUI() {
        contentView = CAOpenAlbumContentView.init(frame: .init(x: 0, y: 0,
                                                               width: view.width,
                                                               height: CAOpenAlbumContentView.viewHeight))
        tabelView.tableHeaderView = contentView
    }
    
    override func rxBind() {
        
    }
}
