//
//  WebViewTicket.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/21/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class WebViewTicket:UIViewController{
    
    let webView = UIWebView()
    var url:URL!
    let backgroundLoading: UIView = {
        let view = UIView()
        var loadingView: UIView!
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
        view.isHidden = true
        loadingView = UIView()
        loadingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        loadingView.layer.cornerRadius = 10
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loading.hidesWhenStopped = true
        return loading
    }()
    
    var toolBar = UIToolbar()
    
    let btnBack =  UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(WebViewTicket.actionBack))
    let btnNext =  UIBarButtonItem(image: #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(WebViewTicket.actionNext))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        super.viewDidLayoutSubviews()
        webView.delegate = self
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: webView)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: toolBar)
        self.view.addViewWithContrains(VSFormat: "V:|[v0][v1(50)]|", views: webView, toolBar)
        let btnHome =  UIBarButtonItem(image: #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(WebViewTicket.actionDismiss))
        let btnSafari =  UIBarButtonItem(image: #imageLiteral(resourceName: "safari").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(WebViewTicket.actionSafafi))
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        btnHome.tintColor = UIColor.iconSelected
        btnBack.tintColor = UIColor.iconSelected
        btnNext.tintColor = UIColor.iconSelected
        btnSafari.tintColor = UIColor.iconSelected
        space.width = UIScreen.main.bounds.width - 150
        toolBar.items = [btnHome, btnBack, btnNext, space, btnSafari]
        self.addLoading()
        webView.loadRequest(URLRequest(url: self.url!))
    }
}

extension WebViewTicket: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showLoading(isShow: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.showLoading(isShow: false)
        self.url = webView.request?.url
        btnBack.isEnabled = webView.canGoBack
        btnNext.isEnabled = webView.canGoForward
    }
}

extension WebViewTicket{
    func addLoading() {
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: backgroundLoading)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]|", views: backgroundLoading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "H:|[v0]|", views: loading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "V:|[v0]|", views: loading)
    }
    
    func showLoading(isShow: Bool) {
        if isShow && self.backgroundLoading.isHidden{
            self.backgroundLoading.isHidden = !isShow
            self.loading.startAnimating()
        }else if !isShow && !self.backgroundLoading.isHidden{
            self.backgroundLoading.isHidden = !isShow
            self.loading.stopAnimating()
        }
    }
    
    func actionDismiss(){
        self.dismiss(animated: true) {
            self.webView.removeFromSuperview()
        }
    }
    
    func actionSafafi(){
        guard let url = self.url else { return }
        self.showLoading(isShow: true)
        UIApplication.shared.open(url, options: [:]) { (done) in
            print(done)
            self.showLoading(isShow: false)
        }
    }
    
    func actionBack(){
        webView.goBack()
    }
    
    func actionNext(){
        webView.goForward()
    }
}
