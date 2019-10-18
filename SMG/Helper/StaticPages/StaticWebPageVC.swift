//
//  StaticWebPageVC.swift
//
//  Created by Amzad on 24/11/15.
//  Copyright © 2015 Syon Infomedia. All rights reserved.
//

import UIKit

enum StaticPage:Int {
    
    case unknown            = -1
    case feedback           = 0
    case contactUs          = 1
    case aboutUs            = 2
    case privacyPolicy      = 3
    case termsConditions    = 4
    case disclaimer         = 5
    case helpTips           = 6
    case fAQ                = 7


    var pageTitle: String {
        switch self {
        case .unknown:
            return ""
        case .feedback:
            return "Feedback"
        case .contactUs:
            return "Contact Us"
        case .aboutUs:
            return "About Us"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsConditions:
            return "Terms and Conditions"
        case .disclaimer:
            return "Disclaimer"
        case .helpTips:
            return "Help"
        case .fAQ:
            return "FAQ"
        }
    }
    
    var pageUrl: String {
        switch self {
        case .unknown:
            return ("http://syonserver.com/html/app")
        case .feedback:
            return (API.baseURL + "Feedback")
        case .contactUs:
            return (API.baseURL + "Contact Us")
        case .aboutUs:
            return (API.baseURL + "about-us")
        case .privacyPolicy:
            return (API.baseURL + "privacy-policy")
        case .termsConditions:
            return (API.baseURL + "terms-and-conditions")
        case .disclaimer:
            return (API.baseURL + "Disclaimer")
        case .helpTips:
            return "https://www.retailasiaacademy.com/loginfaq.html"
        case .fAQ:
            return (API.baseURL + "faqs")
        }
    }

}

extension StaticPage {
    init?(rawInt: Int) {
        // Check if string contains 'carrousel'
        if rawInt >= 0 &&  rawInt <= 7 {
            self.init(rawValue:rawInt)
        } else {
            self.init(rawValue:-1)
        }
    }
}

/*let staticVC  = StaticWebPageVC(nibName: "StaticWebPageVC", bundle: Bundle.main)
 staticVC.pageType = .Unknown
 self.navigationController?.pushViewController(staticVC, animated: true)
 */

class StaticWebPageVC: UIViewController {

    static func nibInstance() -> StaticWebPageVC {
        return StaticWebPageVC(nibName: "StaticWebPageVC", bundle: Bundle.main)
    }


    @IBOutlet weak var webView:UIWebView!
    var pageType:StaticPage = StaticPage.unknown
    var url:URL = URL(string: "http://google.co.in")!
    var cardRequest :URLRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTopBar(left: [.back])
        self.title = self.pageType.pageTitle
        loadWebPage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension StaticWebPageVC :UIWebViewDelegate  {
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Global.dismissLoadingSpinner(self.webView)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Global.dismissLoadingSpinner(self.webView)
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url?.absoluteString

        if url!.contains("appCallback?success=1&callback_type=save_card") {
            //Add card success
            // Finish and dissmiss/close screen 
            ///print("Success callback : \(url?.description)")
           self.navigationController?.popViewController(animated: true)
            return true
        } else if (url!.contains("appCallback?error=1") || url!.contains("appCallback?redirectBack=1")) {
            //Error
            //Show Error alert
            //Global.showAlert(withMessage: "Payment Request has been expired or cancelled.")
            self.navigationController?.popViewController(animated: true)
            return false
        } else {
           // print("Loading URL : \(url?.description)")
            return true
        }
    }
}


extension StaticWebPageVC {
    func loadWebPage(){
        if cardRequest != nil {
            print("URL : \(String(describing: cardRequest.url?.description))")
             self.title = ""
            self.webView.loadRequest(cardRequest)
        }else {
            switch self.pageType {
            case .feedback:
                // self.webView.loadRequest(NSURLRequest(URL: API.FEEDBACK_URL.getPageURL()))
                break
            case .privacyPolicy:
                self.url = (StaticPage.privacyPolicy.pageUrl).makeURL()!
            case .contactUs:
                break
            case .aboutUs:
                self.url = (StaticPage.aboutUs.pageUrl).makeURL()!
            case .termsConditions:
                self.url = (StaticPage.termsConditions.pageUrl).makeURL()!
                break
            case .disclaimer:
                //self.webView.loadRequest(NSURLRequest(URL: API.ABOUT_US_URL.getPageURL()))
                break
            case .helpTips:
                self.url = (StaticPage.helpTips.pageUrl).makeURL()!
                //            url =  URL(string:API.HELP_TIPS.baseURL + API.HELP_TIPS.rawValue)
                break
            case .fAQ:
                self.url = (StaticPage.fAQ.pageUrl).makeURL()!
            case .unknown:
                break
            }
            self.webView.loadRequest(URLRequest(url:self.url))
        }
        
        
    }
}

