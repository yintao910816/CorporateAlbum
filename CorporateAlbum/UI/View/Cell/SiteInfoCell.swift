//
//  SiteInfoCell.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class SiteInfoCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var phoneOutlet: UILabel!
    @IBOutlet weak var summaryoutlet: UILabel!
    @IBOutlet weak var collectOutlet: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var awardOutlet: UIImageView!
    
    weak var delegate: SiteInfoCellActions?
    
    @IBAction func share(_ sender: Any) {
        delegate?.share(model: model)
    }
    
    @IBAction func collected(_ sender: Any) {
        delegate?.collecte(model: model)
    }

    var model: SiteInfoModel! {
        didSet {
            coverOutlet.setImage(model.Logo)
            titleOutlet.text   = model.SiteTitle
            addressOutlet.text = "地址：\(model.Address)"
            phoneOutlet.text   = "电话：\(model.Phone)"
            summaryoutlet.text = model.Keywords
            awardOutlet.isHidden = !(model.HasAward > 0)
        }
    }
    
}


protocol SiteInfoCellActions: class {
    
    func share(model: SiteInfoModel)
    
    func collecte(model: SiteInfoModel)
}
