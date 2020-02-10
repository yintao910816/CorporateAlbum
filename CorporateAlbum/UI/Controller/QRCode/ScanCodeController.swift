//
//  QRCodeSession.swift
//  Mobile4A
//
//  Created by 020-YinTao on 2017/8/11.
//  Copyright © 2017年 wta. All rights reserved.
//

//let kMargin: CGFloat = 35
//let kBorderW: CGFloat = 140
//let scanViewW = UIScreen.main.bounds.width - CGFloat(kMargin * 2)
//let scanViewH = UIScreen.main.bounds.width - CGFloat(kMargin * 2)
//
//let scanRect = CGRect(x: kMargin, y: (PPScreenH - 64 - scanViewH) / 2, width: scanViewW, height: scanViewH)

import UIKit
import AVFoundation

class ScanCodeController: BaseViewController {

    lazy var lightButton: UIButton = {
        let b = UIButton.init(frame: CGRect.init(x: (self.view.width - 150)/2.0, y: self.view.height - 60, width: 150, height: 30))
        b.setTitle("开灯/关灯", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(openLight), for: .touchUpInside)
        return b
    }()
    
    lazy var qRScanView: LBXScanView = {
        let _qRScanView = LBXScanView.init(frame: self.view.bounds, style: self.zhiFuBaoStyle())!
        return _qRScanView
    }()
    
    lazy var zxingObj: ZXingWrapper = {
        let videoView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: self.view.height))
        videoView.backgroundColor = .clear
        self.view.insertSubview(videoView, at: 0)
        let _zxingObj = ZXingWrapper.init(preView: videoView, block: { [weak self] (barcodeFormat, str, scanImg) in
            self?.scanResult(result: str)
        })
        return _zxingObj!
    }()
    
//    lazy var remindLabel: UILabel = {
//        let scanRect = LBXScanView.getZXingScanRect(withPreView: self.view, style: self.zhiFuBaoStyle())
//
//        let text = UILabel.init(frame: CGRect.init(x: 20, y: scanRect.origin.y + 20, width: self.view.bounds.width - 2 * 20, height: 20))
//        text.textAlignment = .center
//        text.text = "将扫描框对准二维码，即可自动扫描"
//        text.font = UIFont.systemFont(ofSize: 15)
//        text.textColor = .black //RGB(54, 54, 54)
//        return text
//    }()
    
    func scanResult(result: String?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if canUseSystemCamera() == true && qRScanView.superview == nil {
            view.addSubview(qRScanView)
            
//            view.addSubview(remindLabel)
            
            qRScanView.startDeviceReadying(withText: "正在启动摄像头...")

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: { [weak self] in
                self?.zxingObj.start()
                self?.qRScanView.startScanAnimation()
                self?.qRScanView.stopDeviceReadying()
            })
        } else if canUseSystemCamera() == true && qRScanView.superview != nil {
            zxingObj.start()
        }
        
        view.addSubview(lightButton)
        view.bringSubviewToFront(lightButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if navigationController?.viewControllers.contains(self) == false {
            zxingObj.stop()
            
            qRScanView.stopScanAnimation()
        }
    }
    
    @objc private func openLight() {
        let d = AVCaptureDevice.default(for: .video)
        if let device = d {
            if device.torchMode == AVCaptureDevice.TorchMode.off{
                do {
                    try device.lockForConfiguration()
                } catch {
                    return
                }
                device.torchMode = .on
                device.flashMode  = .on
                device.unlockForConfiguration()
            }else {
                do {
                    try device.lockForConfiguration()
                } catch {
                    return
                }
                device.torchMode = .off
                device.flashMode = .off
                device.unlockForConfiguration()
            }
        }
    }
    
    fileprivate func canUseSystemCamera() ->Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .restricted || authStatus == .denied {
            NoticesCenter.alert(title: "相机权限受限", message: "请到手机设置打开相机权限")
            return false
        }
        return true
    }
    
    // 模仿支付宝
    func zhiFuBaoStyle() ->LBXScanViewStyle{
        //设置扫码区域参数
        let scanStyle = LBXScanViewStyle.init()
        scanStyle.centerUpOffset = 60
        scanStyle.xScanRetangleOffset = 30
        
        if (PPScreenH <= 480 ){
            //3.5inch 显示的扫码缩小
            scanStyle.centerUpOffset = 40
            scanStyle.xScanRetangleOffset = 20
        }
        
        scanStyle.notRecoginitonArea = RGB(0, 0, 0, 0.6)
        scanStyle.photoframeAngleStyle = .inner
        scanStyle.photoframeLineW = 2.0
        scanStyle.photoframeAngleW = 16
        scanStyle.photoframeAngleH = 16
        
        scanStyle.isNeedShowRetangle = false
        scanStyle.anmiationStyle = .netGrid
        
        //使用的支付宝里面网格图片
        scanStyle.animationImage = UIImage.init(named: "CodeScan.bundle/qrcode_scan_full_net")
        
        return scanStyle
    }
}

extension ScanCodeController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //扫码完成
        if metadataObjects.count > 0{
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                //获取到二维码的数据，可以去处理自己的业务逻辑，比如此处假设我扫描的是一个连接，直接打开这个连接
//                openUrl(result:resultObj.stringValue!) //此处代码就不给了
                PrintLog(resultObj.stringValue)
            }
        }
    }
}

