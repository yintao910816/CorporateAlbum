//
//  CAOpenAlbumFooterContentView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOpenAlbumFooterContentView: BaseView {

    public static let viewHeight: CGFloat = 364

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var arrowOutlet: UIButton!
    @IBOutlet weak var serverAgreementOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var hostOutlet: UITextField!
    @IBOutlet weak var companyOutlet: UILabel!
    @IBOutlet weak var totlePriceOutlet: UILabel!
    
    override func rxBind() {

    }
    
    override func setupUI() {
        contentView = (Bundle.main.loadNibNamed("CAOpenAlbumFooterContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
