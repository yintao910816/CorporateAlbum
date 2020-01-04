//
//  AlbumShareFilesOwner.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/3.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class AlbumShareFilesOwner: BaseFilesOwner {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var siteOutlet: UILabel!
    @IBOutlet weak var awardOutlet: UILabel!
    @IBOutlet weak var webaddressOutlet: UILabel!
    @IBOutlet weak var summaryOutlet: UILabel!
    @IBOutlet weak var lastOutlet: UILabel!
    
    @IBOutlet weak var qrCodeOutlet: UIButton!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBOutlet weak var mainViewHeightCns: NSLayoutConstraint!
    
    private var bookModel: AlbumBookModel?

    private var siteModel: SiteInfoModel?

    @IBAction func okAction(_ sender: Any) {
        contentView.isHidden = true
    }
    
    init(show inView: UIView) {
        super.init()
        contentView = (Bundle.main.loadNibNamed("AlbumShareView", owner: self, options: nil)?.first as! UIView)
        inView.addSubview(contentView)
        inView.bringSubview(toFront: contentView)
        
        contentView.frame = inView.bounds
        
        contentView.isHidden = true
    }
    
    func show(shareBook model: AlbumBookModel) {
            bookModel = model
            
            configBookUI()
            
            contentView.isHidden = false
    }
    
    func show(shareSite model: SiteInfoModel) {
            siteModel = model
            
            configSiteUI()
            
            contentView.isHidden = false
    }
    
    private func configBookUI() {
        qrCodeOutlet.setImage(bookModel!.QRCode)
        lastOutlet.isHidden = true

        titleOutlet.text = "标题：\(bookModel!.Title)"
        siteOutlet.text = "站点：\(bookModel!.Title)"
        awardOutlet.text = "奖励：\(bookModel!.PageCount ) X \(bookModel!.PageAward)分"
        webaddressOutlet.text = "网址：http://\(bookModel!.SiteName)"
        summaryOutlet.text = "简介：\(bookModel!.Summary)"
        
        
        mainView.layoutIfNeeded()
        
        let maxHeight = okOutlet.frame.maxY + 15
        mainViewHeightCns.constant = maxHeight
    }
    
    private func configSiteUI() {
        qrCodeOutlet.setImage(siteModel!.QRCode)
        lastOutlet.isHidden = false
        
        titleOutlet.text = "标题：\(siteModel!.SiteTitle)"
        siteOutlet.text = "资金：\(siteModel!.Funds)"
        awardOutlet.text = "奖励：\(siteModel!.AwardTotal)分"
        webaddressOutlet.text = "电话：\(siteModel!.Mobile)"
        lastOutlet.text = "网址：http://\(siteModel!.SiteName)"
        summaryOutlet.text = "简介：\(siteModel!.Summary)"
        
        mainView.layoutIfNeeded()
        
        let maxHeight = okOutlet.frame.maxY + 15
        mainViewHeightCns.constant = maxHeight
    }

}
