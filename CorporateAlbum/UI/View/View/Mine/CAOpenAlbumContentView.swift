//
//  CAOpenAlbumContentView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOpenAlbumContentView: UIView {

    public static let viewHeight: CGFloat = 916
    
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAOpenAlbumContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
