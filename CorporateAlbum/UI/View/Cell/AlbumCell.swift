//
//  AlbumCell.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/27.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var summaryOutlet: UILabel!
    @IBOutlet weak var bundsOutlet: UIImageView!
    
    @IBOutlet weak var siteLogoButton: TYClickedButton!
    @IBOutlet weak var collecteButton: TYClickedButton!
    @IBOutlet weak var shareButton: TYClickedButton!

    @IBOutlet weak var shareTrailingCns: NSLayoutConstraint!
    
    weak var delegate: AlbumCellActions?
    
    @IBAction func shareAction(_ sender: Any) {
        delegate?.share(model: model)
    }
    
    @IBAction func collecteAction(_ sender: Any) {
        model.IsFavorite = !model.IsFavorite
        delegate?.collecte(model: model)
        collecteButton.isSelected = model.IsFavorite
    }
    
    @IBAction func goToSiteBook(_ sender: UIButton) {
        delegate?.goToSiteBooks(model: model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: AlbumBookModel! {
        didSet{
            coverOutlet.setImage(model.Picture)
            titleOutlet.text = model.Title
            summaryOutlet.text = model.Summary
            bundsOutlet.isHidden = !model.EnabledAward
            siteLogoButton.setImage(model.AppLogo)
        }
    }
    
    var siteLogoIsHidden: Bool? {
        didSet {
            if siteLogoIsHidden == true {
                siteLogoButton.isHidden = true
                shareTrailingCns.constant = 10
            }
        }
    }
    
    /**
     * 计算 cell 高度
     */
    static var cellHeight: CGFloat = {
        // 图片高度
        let imageHeight = (PPScreenW/2.0 - 5*2) * 736.0/414.0
        return (10 + imageHeight + 10 + 20 + 12 + 36 + 15 + 25 + 15)
    }()
}

protocol AlbumCellActions: class {
    
    func share(model: AlbumBookModel)
    
    func collecte(model: AlbumBookModel)
    
    func goToSiteBooks(model: AlbumBookModel)
}
