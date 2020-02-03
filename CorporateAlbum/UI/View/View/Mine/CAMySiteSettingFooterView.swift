//
//  CAMySiteSettingFooterView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAMySiteSettingFooterView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var resetAwardsOutlet: UIButton!
    
    @IBAction func buttonActions(_ sender: UIButton) {
    }
    
    @IBAction func switchActions(_ sender: UISwitch) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAMySiteSettingFooterView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        resetAwardsOutlet.layer.cornerRadius = 17.5
        resetAwardsOutlet.layer.borderColor = RGB(245, 245, 245).cgColor
        resetAwardsOutlet.layer.borderWidth = 1
        
        contentView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
