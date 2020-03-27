//
//  CAShareCorporateContentView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/9.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAShareCorporateContentView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var phoneOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var contactorOutlet: UILabel!
    @IBOutlet weak var mobileOutlet: UILabel!
    @IBOutlet weak var companyUrlOutlet: UILabel!
    
    @IBOutlet weak var birefOutlet: UILabel!
    @IBOutlet weak var qrOutlet: UIImageView!

    public var shareCallBack:((SiteInfoModel)->())?

    @IBAction func actions(_ sender: UIButton) {
        var copyText: String?
        switch sender.tag {
        case 200:
            copyText = titleOutlet.text
        case 201:
            copyText = phoneOutlet.text
        case 202:
            copyText = addressOutlet.text
        case 203:
            copyText = contactorOutlet.text
        case 204:
            copyText = mobileOutlet.text
        case 205:
            copyText = companyUrlOutlet.text
        case 206:
            shareCallBack?(corporateModel)
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
        
        contentView = (Bundle.main.loadNibNamed("CAShareCorporateContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var viewHeight: CGFloat {
        get {
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
            
            return contentView.viewWithTag(206)?.frame.maxY ?? 0
        }
    }
    
    public var corporateModel: SiteInfoModel! {
        didSet {
            titleOutlet.text = corporateModel.SiteTitle
            phoneOutlet.text = corporateModel.Phone
            addressOutlet.text = corporateModel.Address
            contactorOutlet.text = corporateModel.Contactor
            mobileOutlet.text = corporateModel.Mobile
            companyUrlOutlet.text = corporateModel.CompanyUrl
            birefOutlet.text = corporateModel.Summary

            qrOutlet.setImage(corporateModel.QRCode)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
