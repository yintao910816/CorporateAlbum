//
//  CAOpenAlbumContentView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CAOpenAlbumHeaderContentView: BaseView {
    
    public static let viewHeight: CGFloat = 146
        
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerCover: UIImageView!
                
    override func rxBind() {
        headerCover.setImage(APIAssistance.orderHeaderCover)
    }
    
    override func setupUI() {
        contentView = (Bundle.main.loadNibNamed("CAOpenAlbumHeaderContentView", owner: self, options: nil)?.first as! UIView)
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
