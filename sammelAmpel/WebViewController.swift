//
//  WebViewController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 16.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    let webView: UIWebView = {
        let wv = UIWebView()
        return wv
    }()
    
    var html: String?
    
    var urlRequest: URLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if let html = html {
            webView.loadHTMLString(html, baseURL: nil)
        }
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    func setupViews() {
        view.addSubview(webView)
        
        webView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
