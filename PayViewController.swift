//
//  PayViewController.swift
//  PayUFinal
//
//  Created by Mukesh Jha on 19/12/16.
//  Copyright © 2016 Mukesh Jha. All rights reserved.
//

import UIKit

class PayViewController:  UIViewController ,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    let sUrl = "https://www.google.com"
    let fUrl = "https://www.bing.com"
    let PayUBaseUrl:String!="https://test.payu.in"
    var invoice:String?
    var name:String?
    var email:String?
    var amount:String?
    var phone:String?
    var activityIndicatorView:UIActivityIndicatorView!
    var Merchant_Key:String="rjQUPktU";
    var Salt:String="e5iIg1jwi8";
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.title = "Make A Payment"
        webView.delegate=self;
        self.initPayment()
    }
    
    
    
    override func viewDidLoad() {
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.center = self.view.center
        activityIndicatorView.color = UIColor.black
        self.view.addSubview(activityIndicatorView)
        
        invoice="3265489"
        name="Mukesh Jha"
        email="mukeshjha@gmail.com"
        amount="100"
        phone="9886282641"
    }
    
    
    func initPayment() {
        var i = arc4random()
        let service_provider = "payu_paisa"
        let strHash:String = String.localizedStringWithFormat("%d%@", i, NSDate())
        
        let start = strHash.index(strHash.startIndex, offsetBy: 7)
        let end = strHash.index(strHash.endIndex, offsetBy: -6)
        let range = start..<end
        let txnid1 =  strHash.substring(with: range)
        let hashValue = String.localizedStringWithFormat("%@|%@|%@|%@|%@|%@|||||||||||%@",Merchant_Key,txnid1,amount!,invoice!,name!,email!,Salt)
        
        let hash=hashValue.sha512()
        let parms = "txnid="+txnid1+"&key="+Merchant_Key
        let param2="&amount="+amount!+"&productinfo="+invoice!
        let parms1 = "&firstname="+name!+"&email="+email!
        let param4="&phone="+phone!+"&surl="+sUrl+"&furl="+fUrl
        let param3 = "&hash="+hash+"&service_provider="+service_provider
        let postStr = parms+param2+parms1+param4+param3;
        
        
        
        
        
        //        let postStr = "txnid="+txnid1+"&key="+Merchant_Key+"&amount="+amount+"&productinfo="+invoice+"&firstname="+name+"&email="+email+"&phone="+phone+"&surl="+sUrl+"&furl="+fUrl+"&hash="+hash+"&service_provider="+service_provider
        //
        let url:URL = NSURL(string: String.localizedStringWithFormat("%@/_payment", PayUBaseUrl)) as! URL
        //    print("check my url", url, postStr! as URL)
        
        let request = NSMutableURLRequest(url: url)
        do {
            
            let postLength = String.localizedStringWithFormat("%lu",postStr.characters.count)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Current-Type")
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.httpBody = postStr.data(using: String.Encoding.utf8)
            webView.loadRequest(request as URLRequest)
        } catch {
            
        }
        activityIndicatorView.startAnimating()
    }
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.stopAnimating()
        let requestURL = self.webView.request?.url
        let requestString:String = (requestURL?.absoluteString)!
        if requestString.contains("https://www.google.com") {
            print("success payment done")
        }
        else if requestString.contains("https://www.bing.com") {
            print("payment failure")
        }
    }
    
   
    
    
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        activityIndicatorView.stopAnimating()
        print("double failure")
    }

}
