//
//  AlbumPageViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import SnapKit

class AlbumPageViewController: UIViewController {

    var imageView: UIImageView!
    
    private var albumPageModel: AlbumPageModel!
    
    init(albumPageModel: AlbumPageModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.albumPageModel = albumPageModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView.init()
        imageView.setImage(albumPageModel.Picture)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
