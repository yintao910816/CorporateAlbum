//
//  NoticesCenter.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/8.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class NoticesCenter { /**HUD*/

    private var noticeView = HUD.init(.indicator, .dark)
    
    init() { }
    
    public func noticeLoading(_ text: String? = nil, _ inView: UIView = NSObject().visibleViewController!.view) {
        noticeView.showLoading(onView: inView, forText: text)
    }
    
    public func loadingInWindow(_ text: String? = nil) {
        noticeView.showLoading(forText: text)
    }
    
    public func noticeHidden(_ completion: (()-> Void)? = nil) { noticeView.hidden(completion) }
    
    public func successHidden(_ text: String? = nil,  _ completion: (()-> Void)? = nil) {
        noticeView.hiddenSuccess(forText: text, forIntervar: 2, completion)
    }
    
    public func failureHidden(_ text: String? = nil, _ completion: (()-> Void)? = nil) {
        noticeView.hiddenFailure(forText: text, forIntervar: 2, completion)
    }
    
}

extension NoticesCenter { /**alert*/

    public static func alert(title         : String? = nil,
                             message       : String,
                             cancleTitle   : String? = nil,
                             okTitle       : String? = "确定",
                             isLeft        : Bool?   = false,
                             presentCtrl   : UIViewController? = NSObject().visibleViewController,
                             callBackCancle: (() ->Void)? = nil,
                             callBackOK    : (() ->Void)? = nil) {
    
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       
        // message 居左显示 ios8 以上
        if isLeft == true {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineSpacing = 5
            let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]

            let attributedTitle = NSMutableAttributedString.init(string: message)
            attributedTitle.addAttributes(attributes, range: NSRange.init(location: 0, length: message.count))
            alertVC.setValue(attributedTitle, forKey: "attributedMessage")
        }
        
        let okAction = UIAlertAction.init(title: okTitle, style: .default) { _ in
            guard let callBack = callBackOK else{
                return
            }
            callBack()
        }
        alertVC.addAction(okAction)

        if cancleTitle?.isEmpty == false {
            let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel) { _ in
                guard let callBack = callBackCancle else{
                    return
                }
                callBack()
            }
            alertVC.addAction(cancelAction)
        }
        
        presentCtrl?.present(alertVC, animated: true)
    }
    
    public static func alertActions(title         : String? = nil,
                                    messages      : [String],
                                    cancleTitle   : String? = nil,
                                    presentCtrl   : UIViewController? = NSObject().visibleViewController,
                                    callBack      : ((Int) ->Void)? = nil) {
    
        let alertVC = UIAlertController.init(title: title, message: title, preferredStyle: .actionSheet)
               
        for idx in 0..<messages.count {
            let action = UIAlertAction.init(title: messages[idx], style: .default) { _ in
                callBack?(idx)
            }
            alertVC.addAction(action)
        }
        
        if let cancle = cancleTitle {
            let action = UIAlertAction.init(title: cancle, style: .default) { _ in
                callBack?(messages.count)
            }
            alertVC.addAction(action)
        }
                
        presentCtrl?.present(alertVC, animated: true)
    }

}
