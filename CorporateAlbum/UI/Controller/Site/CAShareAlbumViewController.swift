//
//  CAShareAlbumViewController.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/8.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAShareAlbumViewController: BaseViewController {

    private var albumModel: AlbumBookModel!
    
    @IBOutlet weak var tableView: UITableView!
    private var header: CAShareAlbumContentView!
    
    override func setupUI() {
        header = CAShareAlbumContentView.init(frame: view.bounds)
        header.albumModel = albumModel
        let headerHeight = header.viewHeight
        header.frame = .init(x: 0, y: 0, width: view.width, height: headerHeight)
        
        tableView.tableHeaderView = header
        
    }
    
    override func rxBind() {
        header.shareCallBack = {
            ShareUtils.presentShare(thumbURL: $0.Picture, title: $0.Title, descr: $0.Summary, webpageUrl: $0.AlbumUrl)
        }
    }
    
    override func prepare(parameters: [String : Any]?) {
        albumModel = (parameters!["model"] as! AlbumBookModel)
    }
}
