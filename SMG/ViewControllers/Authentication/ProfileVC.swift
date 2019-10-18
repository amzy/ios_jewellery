//
//  ProfileVC.swift
//  SMG
//
//  Created by Amzad Khan on 02/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit
enum VCType: String {
    case profile      = "profile"
    case editProfile  = "editProfile"
}

class ProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    var type = VCType.editProfile
    @IBOutlet weak var txtFullName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtGSTNo: CustomTextField!
    @IBOutlet weak var txtFirmName: CustomTextField!
    @IBOutlet weak var txtFirmAddress: CustomTextField!
    @IBOutlet weak var txtDesignation: CustomTextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnTermCondition: UIButton!
    var userPhoto:Photo?
    
    var userID:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.type == .editProfile {
            self.configureTopBar(left: [.leftMenu], right: [.call])
        }else {
            self.navigationItem.leftBarButtonItem = nil
            //self.configureTopBar(left: [.back])
            self.navigationItem.setHidesBackButton(true, animated:true);
            
            self.apiLoadUserData()
        }
        self.btnSave.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }
    func configureView() {
        
        guard let user = Constants.kAppDelegate.user else {return}
        
        txtFullName?.text    = user.name
        txtEmail?.text       = user.email
        txtFirmName?.text    = user.firmName
        txtGSTNo?.text       = user.gstNo
        txtFirmName?.text    = user.firmName
        txtDesignation?.text = user.designation
        txtFirmAddress?.text = user.firmAddress
        
        self.userPhoto = user.avatar
        
        if let image = user.avatar?.image {
            userImage?.image = image
        }else{
            guard let url = user.avatar?.url else {return}
            userImage?.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "man_avatar"), handler: nil)
        }
        
        if self.type == .editProfile {
            
        }
    }
    func userData() ->User {
        let user  = Constants.kAppDelegate.user
        user?.gstNo       = self.txtGSTNo.text
        user?.designation = self.txtDesignation.text
        user?.firmAddress = self.txtFirmAddress.text
        user?.firmName    = self.txtFirmName.text
        user?.email       = self.txtEmail.text
        user?.fullName    = self.txtFullName.text
        
        return user!
    }
    
    func validateProfile() ->Bool {
        guard let fullName =  txtFullName.text, fullName.count > 0 else {
            //Enter FullName
            Global.showAlert(message: "Enter Full Name.")
            return false
        }
        guard let email =  txtEmail.text, ValidationRules.isValid(email:email ) == false else {
            //Enter Valid Email
            Global.showAlert(message: "Enter valid email address.")
            return false
        }
        guard let firmName =  txtFirmName.text, firmName.trim().count > 0 else {
            //Enter Valid Firm Name
            Global.showAlert(message: "Enter valid firm name.")
            return false
        }
        guard let firmGST =  txtGSTNo.text, ValidationRules.isValid(gstNo: firmGST) == false else {
            //Enter Valid GST No
            Global.showAlert(message: "Enter valid GST No.")
            return false
        }
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapUserImage(_ sender: Any) {
        UIViewController.openImagePicker(sender: self)
        
    }
    @IBAction func didTapSave(_ sender: Any) {
        //Constants.kAppDelegate.applicationLoggedInSuccessfully(nil)
        if self.validateProfile(){
            let user = self.userData()
            self.apiUpdateProfile(user:user, userImage: self.userImage.image)
        }
    }
}
extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("PickerInfo:\((info as NSDictionary))")
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == "public.image" {
                print("Image Selected")
                if let selectedImage = UIImage.from(info: info)?.fixOrientation() {
                    // I am happy :)
                    //let image  = Media(selectedImage)
                    self.userPhoto =  Photo(selectedImage)
                    self.userImage.image = selectedImage
                    dismiss(animated: false) {}
                    
                } else {
                    // I am sad :(
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC {
    
    func apiUpdateProfile(user:User, userImage:UIImage?){
        Global.showLoadingSpinner(sender: self.view)
        
        var files:[String:UIImage]?
        if let photo = self.userPhoto, photo.isUploaded == false {
            files = ["profile_pic" : photo.image]
            user.avatar = photo
        }
        
        API.updateProfile.requestUpload(with: user.uploadData(), files: files, success: { (jsonObject) in
            Global.dismissLoadingSpinner(self.view)
            Constants.kAppDelegate.user = user
            Constants.kAppDelegate.user.saveUser()
            
            if let data = jsonObject?["msg"] as? String {

                Global.showAlert(message: data, handler: { (okay) in
                    if self.type == .profile {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        //Constants.kAppDelegate.applicationLoggedInSuccessfully(nil)
                    }
                })
            }else {
                if self.type == .profile {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    //Constants.kAppDelegate.applicationLoggedInSuccessfully(nil)
                }
            }
            
        }) { (error, jsonObject) in
            Global.dismissLoadingSpinner(self.view)
            //Error Handlig
        }
    }
    func apiLoadUserData() {
        if User.isUserLogin() != nil {
            Global.showLoadingSpinner(sender: self.view)
            if let request = API.getProfile.request(method: .get, with: [:]) {
                Global.dismissLoadingSpinner(self.view)
                request.responseJSON { response in
                    API.getProfile.validatedResponse(response, success: { (jsonObject) in
                        guard let data = jsonObject?["data"] as? [String:Any] else {return}
                        let user = User.parse(json: data)
                        user.accessToken = Constants.kAppDelegate.user.accessToken ?? ""
                        user.firmAddress = Constants.kAppDelegate.user.firmAddress
                        user.avatar = Constants.kAppDelegate.user.avatar
                        user.saveUser()
                        Constants.kAppDelegate.user = user
                        self.configureView()
                        
                    }, failed: {(error, json) in
                        
                    })
                }
            }
        }
    }
}
/*
name:Rakesh  Mishra
email:rakeshmishrait@gmail.com
gst_no:123456789
frim_name:smgbangle
designation:Developer
mobile:987343434343434
user_id:100,
profile_pic:file type image.
*/
