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
    @IBOutlet weak var summaryoutlet: UILabel!
    @IBOutlet weak var collectOutlet: TYClickedButton!
    @IBOutlet weak var shareOutlet: TYClickedButton!
    @IBOutlet weak var awardOutlet: UIImageView!
    
    weak var delegate: SiteInfoCellActions?
    
    @IBAction func share(_ sender: Any) {
        delegate?.share(model: model)
    }
    
    @IBAction func collected(_ sender: Any) {
        model.IsFavorite = !model.IsFavorite
        delegate?.collecte(model: model)

        collectOutlet.isSelected = model.IsFavorite
    }

    var model: SiteInfoModel! {
        didSet {
            coverOutlet.setImage(model.AppLogo)
            titleOutlet.text   = model.SiteTitle
            summaryoutlet.text = model.Summary
            awardOutlet.isHidden = !(model.EnableAward && model.ReadCount < model.AwardPageCount)
            collectOutlet.isSelected = model.IsFavorite
        }
    }
}


protocol SiteInfoCellActions: class {
    
    func share(model: SiteInfoModel)
    
    func collecte(model: SiteInfoModel)
}
