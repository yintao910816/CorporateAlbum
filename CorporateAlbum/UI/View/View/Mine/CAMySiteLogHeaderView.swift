//
//  CAMySiteLogHeaderView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAMySiteLogHeaderView: UIView {

    public static let viewHeight: CGFloat = 159
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var siteURLOutlet: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAMySiteLogHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public var model: CAMySiteModel! {
        didSet {
            titleOutlet.text = model.SiteTitle
            siteURLOutlet.text = model.SiteUrl
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
