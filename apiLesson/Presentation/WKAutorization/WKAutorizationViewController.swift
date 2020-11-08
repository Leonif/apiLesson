//
//  WKAutorizationViewController.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 24.09.2020.
//

import UIKit
import Alamofire
import WebKit
import SwiftKeychainWrapper

class WKAutorizationViewController: UIViewController {
    
    let rootView = WKAutorizationView()
    var autorised: ((Bool) -> Void)?
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.navigationDelegate = self
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7611455"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        rootView.load(request)
    }
}


extension WKAutorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"],  let userId = params["user_id"] {
            
            ApiManager.session.token = token
            ApiManager.session.userId = userId
            
            autorised?(true)
        } else {
            autorised?(false)
        }
        
        
        decisionHandler(.cancel)
    }
}
