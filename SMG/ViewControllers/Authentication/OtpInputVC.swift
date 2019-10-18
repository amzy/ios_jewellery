//
//  OtpInputVC.swift
//  SMG
//
//  Created by Amzad Khan on 01/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class OtpInputVC: UIViewController {
    
    var mobileNumber:String?
    @IBOutlet weak var txtOTP: CustomTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    var phone:String!
    var userID:String!
    var testToken:String?
    
    var seconds = 120
    var timer = Timer()
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
        runTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        
        self.title = "OTP"
        self.configureTopBar(left: [.back], right: [.call])
        self.btnSubmit.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
        
        self.txtOTP.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        self.txtOTP.layer.borderWidth = 1
        
        txtOTP.keyboardType = .phonePad

        guard let token = self.testToken else {return}
        txtOTP.text = token
        
    }
    @IBAction func didTapSubmit(_ sender: Any) {
        guard self.phone != nil, self.userID != nil else {
            //User Data not available
            return
        }
        guard let token = self.txtOTP.text, phone.length > 0  else {
            //Input valid token
            return
        }
        self.apiVerifyToken(token: token, phone: self.phone, userID: self.userID)
    }
    @IBAction func didTapResend(_ sender: Any) {
        guard self.phone != nil, self.userID != nil else {
            //User Data not available
            return
        }
        self.apiRegisterPhone(phone: self.phone)
        
    }
}
extension OtpInputVC {
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        //isTimerRunning = true
        //pauseButton.isEnabled = true
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 60
        timerLabel?.text = timeString(time: TimeInterval(seconds))
        //isTimerRunning = false
        //pauseButton.isEnabled = false
       // startButton.isEnabled = true
    }
    
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            self.btnResend.isUserInteractionEnabled = true
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLabel?.text = timeString(time: TimeInterval(seconds))
            //timerLabel?.text = String(seconds)
            //            labelButton.setTitle(timeString(time: TimeInterval(seconds)), for: UIControlState.normal)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours > 0 {
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }else {
            return String(format:"%02i:%02i", minutes, seconds)
        }
    }
}
extension OtpInputVC {
    func apiRegisterPhone(phone:String) {
        if let request = API.registerMobile.request(method: .post, with: ["user_phone":"\(phone)"]) {
            self.btnResend.isUserInteractionEnabled = false
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.registerMobile.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    
                    }, failed: nil)
            }
        }
    }
    func apiVerifyToken(token:String, phone:String, userID:String) {
        if let request = API.verifyUserToken.request(method: .post, with: ["user_phone":"\(phone)","token":"\(token)", "user_id":"\(userID)" ]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.verifyUserToken.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message: data, handler: { (okay) in
                            Constants.kAppDelegate.user = User()
                            Constants.kAppDelegate.user.id = userID
                            Constants.kAppDelegate.user.phone = phone
                            Constants.kAppDelegate.user.saveUser()
                            NotificationCenter.default.post(name: .kDidLoginUser, object: nil)
                            let vc =  ProfileVC.instantiate(fromAppStoryboard: .authentication)
                            vc.type = .profile
                            strongSelf.navigationController?.pushViewController(vc, animated: true)
                        })
                    }else {
                        Constants.kAppDelegate.user = User()
                        Constants.kAppDelegate.user.id = userID
                        Constants.kAppDelegate.user.phone = phone
                        Constants.kAppDelegate.user.saveUser()
                        NotificationCenter.default.post(name: .kDidLoginUser, object: nil)
                        let vc =  ProfileVC.instantiate(fromAppStoryboard: .authentication)
                        vc.type = .profile
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
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
