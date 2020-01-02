//
//  Animotions.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/2.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

/** https://www.jianshu.com/p/8b77ad5dac97 */

class DropCoinAnimotion: NSObject {
    
    private var animotionViews = [UIView]()
    
    init(count: Int, view: UIView) {
        super.init()
        
        startAnimotion(count: count, view: view)
    }
    
    static func startAnimotion(count: Int, view: UIView) {
        let _ = DropCoinAnimotion.init(count: count, view: view)
    }
    
    private func startAnimotion(count: Int, view: UIView) {
        for _ in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                let imageView = UIImageView.init(frame: CGRect.init(x: view.width / 2.0, y: 100, width: 50, height: 50))
                imageView.image = UIImage.init(named: "coin")
                view.addSubview(imageView)
                view.bringSubview(toFront: imageView)
                
                self?.animotionViews.append(imageView)
                
                self?.addAnimotin(imageView, startPoint: imageView.origin,
                                  endPoint: .init(x: view.width / 2.0, y: view.height - 200))
            }
        }
    }
    
    private func addAnimotin(_ view: UIView, startPoint: CGPoint, endPoint: CGPoint) {
        let movePath = UIBezierPath()
        movePath.move(to: startPoint)
        movePath.addLine(to: endPoint)
        
        let animotion = CAKeyframeAnimation.init(keyPath: "position")
        animotion.path = movePath.cgPath
        animotion.duration = 1.0
        animotion.autoreverses = false
        animotion.repeatCount = 1
        animotion.calculationMode = kCAAnimationPaced
        animotion.delegate = self
        
        view.layer.add(animotion, forKey: nil)
    }

}

extension DropCoinAnimotion: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag == true {
//            for view in animotionViews { view.removeFromSuperview() }
//        }
    }
}
