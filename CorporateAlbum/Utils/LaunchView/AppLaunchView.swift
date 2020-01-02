//
//  AppLaunchView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/31.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class AppLaunchView: UIView {

    fileprivate var imageSource: [String]!
    
    typealias hiddenCallBack = () ->Void
    
    private var callBack: hiddenCallBack?
    
    override init(frame: CGRect) {
        let aframe = UIScreen.main.bounds
        super.init(frame: aframe)
        imageSource = UIDevice.current.isX == true ? ["lancuh_01_x", "lancuh_02_x", "lancuh_03_x"]
            : ["lancuh_01", "lancuh_02", "lancuh_03"]
        
        addSubview(scroll)
        addImageView()
        
        addSubview(hiddenButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        PrintLog("释放了 \(self)")
    }
    //MARK:
    //MARK: public
    public func show(complement: hiddenCallBack?) {
        callBack = complement
        
        let awindow = UIApplication.shared.delegate?.window!
        awindow?.addSubview(self)
        awindow?.bringSubview(toFront: self)
        
        userDefault.lanuchStatue = vLaunch
    }
    
    //MARK:
    //MARK: private
    private func addImageView() {
        for idx in 0..<imageSource.count {
            let path = Bundle.main.resource(fileName: imageSource[idx],
                                            ofType: "jpg",
                                            subDirectory: "lanuch")
            let imgView = UIImageView.init(image: UIImage.init(contentsOfFile: path))
            let x = bounds.width * CGFloat(idx)
            imgView.frame = CGRect.init(x: x, y: 0, width: bounds.width, height: bounds.height)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            scroll.addSubview(imgView)
            
            if idx == imageSource.count - 1 {
//                imgView.isUserInteractionEnabled = true
//                imgView.addGestureRecognizer(tapGes)
                imgView.isUserInteractionEnabled = true
                imgView.addSubview(goButton)
            }
        }
    }
    
    // 隐藏引导页
    @objc private func hiddenSelf() {
        let animotion = CABasicAnimation.init(keyPath: "opacity")
        animotion.delegate = self
        animotion.fromValue = NSNumber.init(value: 1.0)
        animotion.toValue   = NSNumber.init(value: 0.0)
        animotion.duration  = 0.2
        //以下两行同时设置才能保持移动后的位置状态不变
        animotion.fillMode = kCAFillModeForwards
        animotion.isRemovedOnCompletion = false
        layer.add(animotion, forKey: "GuideView")
    }
    
    //MARK:
    //MARK: lazy
    lazy var scroll: UIScrollView = {
        let _scroll = UIScrollView.init(frame: self.bounds)
        _scroll.showsHorizontalScrollIndicator = false
        _scroll.isPagingEnabled = true
        _scroll.bounces         = false
        _scroll.contentSize     = CGSize.init(width: self.bounds.size.width * CGFloat(self.imageSource.count), height: self.bounds.size.height)
        return _scroll
    }()
    
    lazy var hiddenButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: width - 60, y: LayoutSize.topVirtualArea + 20, width: 40, height: 20))
        button.setTitle("跳过", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.cornerRadius = 10
        button.layer.borderColor  = UIColor.white.cgColor
        button.layer.borderWidth  = 1
        button.addTarget(self, action: #selector(hiddenSelf), for: .touchUpInside)
        return button
    }()

    lazy var goButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: (width - 110)/2, y: height - 150, width: 110, height: 30))
        button.setTitle("立即进入", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = CA_MAIN_COLOR
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(hiddenSelf), for: .touchUpInside)
        return button
    }()
    
    lazy var tapGes: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenSelf))
        return tap
    }()

}

extension AppLaunchView: CAAnimationDelegate {
    
    //MARK:
    //MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let c = callBack {
            c()
        }
        
        imageSource.removeAll()
        removeFromSuperview()
        layer.removeAllAnimations()
    }
    
}
