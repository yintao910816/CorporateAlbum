//
//  CASetAlipayInfoContentView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CASetAlipayInfoContentView: UIView {
    public static let normalHeight: CGFloat = 327
    public static let heigherHeight: CGFloat = 427

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var codeOutlet: UITextField!
    @IBOutlet weak var getCodeOutlet: UIButton!
    @IBOutlet weak var alipayOutlet: UITextField!
    @IBOutlet weak var idCardOutlet: UITextField!
    @IBOutlet weak var cameraOutlet: UIButton!
    @IBOutlet weak var idCardImageOutlet: UIImageView!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var remindTopCns: NSLayoutConstraint!
    
    public var clickedCameraCallBack: (()->())?
    
    @IBAction func actions(_ sender: UIButton) {
        clickedCameraCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CASetAlipayInfoContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
        
        idCardImageOutlet.isHidden = true
        remindTopCns.constant = 30
        
        getCodeOutlet.layer.cornerRadius = 5
        getCodeOutlet.layer.borderWidth = 1
        getCodeOutlet.layer.borderColor = RGB(8, 172, 222).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

    public var model: UserInfoModel! {
        didSet {
            alipayOutlet.text = model.Alipay
        }
    }

    public func reloadIdCardImage(_ image: UIImage?) {
        idCardImageOutlet.image = image
        idCardImageOutlet.isHidden = false
        remindTopCns.constant = 130
    }

}
