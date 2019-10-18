//
//  PhoneInputVC.swift
//  SMG
//
//  Created by Amzad Khan on 29/08/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit
import CTKFlagPhoneNumber

class PhoneInputVC: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var phoneNumber: CustomTextField!//CTKFlagPhoneNumberTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
    }
    func configureView(){
        self.title = "Registration"
        self.configureTopBar(left: [.dismiss], right: [.call])
        //self.btnSubmit.applyCardEffect()
        
        self.btnSubmit.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1) ])
        
        self.phoneNumber.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        self.phoneNumber.layer.borderWidth = 1
        //phoneNumber.parentViewController = self
        
        if let code = Locale.current.regionCode {
            //phoneNumber.setFlag(for: code)
        }
        
        //phoneNumber.flagSize = CGSize.zero
        phoneNumber.keyboardType = .phonePad
        // phoneNumber.leftViewMode = .never
        // phoneNumber.leftView = UIView()
        //self.navigationItem.leftBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapSubmit(_ sender: Any) {
        
        guard let phone = self.phoneNumber.text, phone.length > 0 , phone.length < 11 else {
            //Input valid number
            return
        }
        self.apiRegisterPhone(phone: phone)
       
    }
}
extension PhoneInputVC {
    func apiRegisterPhone(phone:String) {
        self.view.endEditing(true)
        if let request = API.registerMobile.request(method: .post, with: ["user_phone":"\(phone)"]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.registerMobile.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["msg"] as? String {
                        //Global.showAlert(message: data)
                        Global.showAlert(message: data, handler: { (okay) in
                            if let userID   = jsonObject?["user_id"] {
                                let userId  = "\(userID)"
                                let token   = jsonObject?["token"] as? String
                                
                                let vc = OtpInputVC.instantiate(fromAppStoryboard: .authentication)
                                vc.testToken = token
                                vc.userID    = userId
                                vc.phone     = phone
                                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            }
                        })
                    }else {
                        if let userID   = jsonObject?["user_id"] {
                            let userId  = "\(userID)"
                            let token   = jsonObject?["token"] as? String
                            
                            let vc = OtpInputVC.instantiate(fromAppStoryboard: .authentication)
                            vc.testToken = token
                            vc.userID    = userId
                            vc.phone     = phone
                            strongSelf.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            Global.showAlert(message: errorObj.localizedDescription)
                        }
                })
            }
        }
    }
}
