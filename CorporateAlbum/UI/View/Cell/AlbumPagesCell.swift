//
//  AlbumPagesCell.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class AlbumPagesCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var awardOutlet: UIImageView!
    
    var model: AlbumPageModel! {
        didSet {
            coverOutlet.setImage(model.Picture)
            awardOutlet.isHidden = !model.HasAward
        }
    }
    
}
