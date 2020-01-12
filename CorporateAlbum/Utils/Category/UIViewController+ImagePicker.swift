//
//  UIViewController+ImagePicker.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

public protocol PropertyStoring {
    
    associatedtype T
    associatedtype AlbumT
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: AlbumT) -> AlbumT
}

public extension PropertyStoring {
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: AlbumT) -> AlbumT {
        guard let value = objc_getAssociatedObject(self, key) as? AlbumT else {
            return defaultValue
        }
        return value
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PropertyStoring {
    
    public typealias T = String
    public typealias AlbumT = Int
    private struct CustomProperties {
        static var imgType = UIImagePickerControllerOriginalImage
        static var isAlbum = UIImagePickerControllerSourceType.photoLibrary
    }
    var imgType: String {
        get {
            return getAssociatedObject(&CustomProperties.imgType, defaultValue: CustomProperties.imgType)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.imgType, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var albumType: Int {
        get {
            return getAssociatedObject(&CustomProperties.isAlbum, defaultValue: CustomProperties.isAlbum.rawValue)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.isAlbum, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func invokingSystemAlbumOrCamera(type: String, albumT: Int) -> Void {
        
        self.imgType = type
        self.albumType = albumT
        if albumT == UIImagePickerControllerSourceType.photoLibrary.rawValue {
            self.invokeSystemPhoto()
        }else {
            self.invokeSystemCamera()
        }
    }
    
    func invokeSystemPhoto() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            if self.imgType == UIImagePickerControllerEditedImage {
                imagePickerController.allowsEditing = true
            }else {
                imagePickerController.allowsEditing = false
            }
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            }
            self.present(imagePickerController, animated: true, completion: nil)
        }else {
            NoticesCenter.alert(title: nil, message: "请打开允许访问相册权限！")
        }
    }
    
    func invokeSystemCamera() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.mediaTypes = ["public.image"]
            self.imgType = UIImagePickerControllerOriginalImage
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            }
            self.present(imagePickerController, animated: true, completion: nil)
        }else {
            NoticesCenter.alert(title: nil, message: "请打开允许访问相机权限！")
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        picker.dismiss(animated: true, completion: {
            
            let img: Any = info[self.imgType] as Any
            if (img is UIImage) {
                if self.albumType == UIImagePickerController.SourceType.photoLibrary.rawValue {
                    self.reloadViewWithImg(img: img as! UIImage)
                }else {
                    self.reloadViewWithCameraImg(img: img as! UIImage)
                }
            }else {
                
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
