//
//  NavigationController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/6/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
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
        self.addLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addLoading() {
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: backgroundLoading)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]-49-|", views: backgroundLoading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "H:|[v0]|", views: loading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "V:|[v0]|", views: loading)
    }
}
