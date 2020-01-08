//
//  CAShareAlbumContentView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/8.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAShareAlbumContentView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var corporationOutlet: UILabel!
    @IBOutlet weak var albumTitleOutlet: UILabel!
    @IBOutlet weak var albumAddressOutlet: UILabel!
    @IBOutlet weak var siteAddressOutlet: UILabel!
    @IBOutlet weak var birefOutlet: UILabel!
    @IBOutlet weak var qrOutlet: UIImageView!
    
    public var shareCallBack:((AlbumBookModel)->())?
    
    @IBAction func actions(_ sender: UIButton) {
        var copyText: String?
        switch sender.tag {
        case 200:
            copyText = corporationOutlet.text
        case 201:
            copyText = albumTitleOutlet.text
        case 202:
            copyText = albumAddressOutlet.text
        case 203:
            copyText = siteAddressOutlet.text
        case 204:
            shareCallBack?(albumModel)
        default:
            break
        }
        
        if copyText != nil {
            UIPasteboard.general.string = copyText
            NoticesCenter.alert(message: "复制成功")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAShareAlbumContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var viewHeight: CGFloat {
        get {
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
            
            return contentView.viewWithTag(204)?.frame.maxY ?? 0
        }
    }
    
    public var albumModel: AlbumBookModel! {
        didSet {
            corporationOutlet.text = albumModel.Company
            albumTitleOutlet.text = albumModel.Title
            albumAddressOutlet.text = albumModel.AlbumUrl
            siteAddressOutlet.text = albumModel.SiteUrl
            birefOutlet.text = albumModel.Summary
            
            qrOutlet.setImage(albumModel.QRCode)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
    
}
