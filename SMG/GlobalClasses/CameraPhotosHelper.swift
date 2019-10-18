//
//  CameraPhotosHelper.swift
//
//  Created by Amzad Khan on 3/8/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Photos
import AVFoundation
import MobileCoreServices


//MARK:- Image Picker Class.
extension UIViewController {
    
    class func openImagePicker(sender:UIViewController) {
        
        sender.view.endEditing(true)
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "Choose an image", style: UIAlertActionStyle.default, handler:{(action) in
            sender.openImageGalley(sender: sender)
        }))
        alertView.addAction(UIAlertAction(title: "Take a image", style: UIAlertActionStyle.default, handler:{(action) in
            sender.openCamera(sender: sender)
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        sender.present(alertView, animated: true, completion: nil)
    }
    
    func openImageGalley(sender:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = sender as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary //imagePicker.mediaTypes =
            picker.navigationBar.barTintColor = UIColor.appNavigation
            sender.present(picker, animated: true, completion: nil)
        } else {
            self.showAlertWith(Title: "No Photo Library", message: "Sorry, this device has no Photo Library")
        }
        
    }
    func openCamera(sender:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = sender as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            sender.present(picker, animated: true, completion: nil)
        } else {
            self.showAlertWith(Title: "No Camera", message: "Sorry, this device has no camera")
        }
        
    }
    
    func userAuthorizedForCamera(handler:@escaping (Bool)->Swift.Void) {
        
        return self.cameraAuthorizationStatus(handler)
    }
    
    func userAuthorizedForPhotos(handler:@escaping (Bool)->Swift.Void) {
        return self.photoAuthorizationStatus(status: PHPhotoLibrary.authorizationStatus(), handler: handler)
    }
    
    //Mark: Private API's for
    fileprivate func displayAuthorization(with message:String) {
        Global.showAlert(message: message, sender: self, setTwoButton: true, setFirstButtonTitle: "Settings", setSecondButtonTitle: "Denied", handler: { (action) in
            if action.title == "Settings" {
                // perhaps use action.title here
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                    UIApplication.shared.openURL(settingsURL as URL)
                }
            }
        })
    }
    
    fileprivate func photoAuthorizationStatus(status:PHAuthorizationStatus, handler:@escaping (Bool)->Swift.Void) {
        switch  status {
        case .authorized:
            handler(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                return self.photoAuthorizationStatus(status: status, handler: handler)
            })
        case .denied:
            self.displayAuthorization(with: "This app requires access to photo library to share images properly.")
            handler(false)
        case .restricted:
            Global.showAlert(message:"This application is not authorized to access photo data, possibly due to active restrictions.")
            handler(false)
        }
    }
    
    fileprivate func cameraAuthorizationStatus(_ handler: @escaping (Bool)->Swift.Void) {
        switch  AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            handler(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: handler)
            break
        case .denied:
            self.displayAuthorization(with: "This app requires access to camera.")
            handler(false)
        case .restricted:
            Global.showAlert(message:"This application is not authorized to access photo data, possibly due to active restrictions.")
            handler(false)
        }
    }
}
/*
extension UIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
}*/
