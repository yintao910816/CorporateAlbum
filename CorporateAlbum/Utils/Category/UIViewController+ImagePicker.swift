//
//  UIViewController+ImagePicker.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import Photos
import AVFoundation


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var imgType: UIImagePickerController.InfoKey {
        get {
            if let type = objc_getAssociatedObject(self, &AssociatedKey.imageTypeKey) as? UIImagePickerController.InfoKey {
                return type
            }
            return UIImagePickerController.InfoKey.originalImage
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKey.imageTypeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var sourceType: UIImagePickerController.SourceType {
        get {
            if let sourceType = objc_getAssociatedObject(self, &AssociatedKey.sourceTypeKey) as? UIImagePickerController.SourceType {
                return sourceType
            }
            return UIImagePickerController.SourceType.photoLibrary
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKey.sourceTypeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
        
    func invokingSystemAlbumOrCamera(type: UIImagePickerController.InfoKey, sourceType: UIImagePickerController.SourceType) -> Void {
        self.imgType = type
        self.sourceType = sourceType
        if sourceType == UIImagePickerController.SourceType.photoLibrary {
            self.invokeSystemPhoto()
        }else {
            self.invokeSystemCamera()
        }
    }
    
    func invokeSystemPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            requestPhotoAuthorization { [weak self] in
                if $0 {
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
                    
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = false
                    if self?.imgType == UIImagePickerController.InfoKey.editedImage {
                        imagePickerController.allowsEditing = true
                    }else {
                        imagePickerController.allowsEditing = false
                    }
                    
                    if #available(iOS 11.0, *) {
                        UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                    }
                    
                    self?.sourceType = .photoLibrary
                    self?.present(imagePickerController, animated: true, completion: nil)
                }else {
                    NoticesCenter.alert(title: nil, message: "请打开允许访问相册权限！")
                }
            }
        }else {
            NoticesCenter.alert(title: nil, message: "设备不支持相册！")
        }
    }
    
    func invokeSystemCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            requestCameraAuthorization { [weak self] in
                if $0 {
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = false
                    imagePickerController.cameraCaptureMode = .photo
                    imagePickerController.mediaTypes = ["public.image"]
                    if #available(iOS 11.0, *) {
                        UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                    }
                    self?.sourceType = .camera
                    self?.present(imagePickerController, animated: true, completion: nil)
                }else {
                    NoticesCenter.alert(title: nil, message: "请打开允许访问相册权限！")
                }
            }
        }else {
            NoticesCenter.alert(title: nil, message: "设备不支持相机！")
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let strongSelf = self else { return }
            
            if let img = info[strongSelf.imgType] as? UIImage {
                if strongSelf.sourceType == UIImagePickerController.SourceType.photoLibrary {
                    strongSelf.reloadViewWithImg(img: img)
                }else {
                    strongSelf.reloadViewWithCameraImg(img: img)
                }
            }
        })
    }
        
    @objc func reloadViewWithImg(img: UIImage) -> Void {
        
    }
    
    @objc func reloadViewWithCameraImg(img: UIImage) -> Void {
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    
    private struct AssociatedKey {
        static var imageTypeKey: String = "imageType"
        static var sourceTypeKey: String = "sourceTypeKey"
    }
    
    private func requestPhotoAuthorization(result: @escaping (Bool)->()) {
        PHPhotoLibrary.requestAuthorization({ (status) in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    result(false)
                case .restricted://此应用程序没有被授权访问的照片数据
                    result(false)
                case .denied://用户已经明确否认了这一照片数据的应用程序访问
                    result(false)
                case .authorized://已经有权限
                    result(true)
                default:
                    result(false)
                }
            }
        })
    }
    
    private func requestCameraAuthorization(result: @escaping (Bool)->()) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        result(true)
                    }else {
                        result(false)
                    }
                }
            }
        case .authorized:
            result(true)
        default:
            result(false)
        }
    }
}
