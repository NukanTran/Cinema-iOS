//
//  WebViewTrailer.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/12/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import MIBlurPopup

class WebViewTrailer:UIViewController{
    
    var url:URL!
    var webView = UIWebView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.layer.cornerRadius = 3
        webView.scrollView.isScrollEnabled = false
        webView.clipsToBounds = true
        webView.delegate = self
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: webView)
        webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 2/3).isActive = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionDismiss)))
        self.addLoading()
        self.showLoading(isShow: true)
        webView.loadRequest(URLRequest(url: self.url!))
        print(url)
    }
    
    func actionDismiss(){
        self.webView.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension WebViewTrailer:MIBlurPopupDelegate{
    
    var popupView: UIView {
        return self.view
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount: CGFloat {
        return 0.3
    }
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}

extension WebViewTrailer: UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.showLoading(isShow: false)
    }
}

extension WebViewTrailer{    
    func addLoading() {
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: backgroundLoading)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]|", views: backgroundLoading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "H:|[v0]|", views: loading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "V:|[v0]|", views: loading)
    }
    
    func showLoading(isShow: Bool) {
        self.backgroundLoading.isHidden = !isShow
        if isShow {
            self.loading.startAnimating()
        }else {
            self.loading.stopAnimating()
        }
    }
}
