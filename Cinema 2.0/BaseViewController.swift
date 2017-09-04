//
//  ViewController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var imageBackground = #imageLiteral(resourceName: "background")
    var shareItem:ShareItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.iconSelected
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.icon, NSFontAttributeName: UIFont.semibold?.size(17) ?? UIFont.systemFont(ofSize: 17)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.setBackgroundImage(image: #imageLiteral(resourceName: "background"))
        
    }
}

extension BaseViewController{
    
    func addSubView(){
    }
    
    func loadData(){
        
    }
    
    func showLoading(isShow: Bool) {
        if let nav = self.navigationController as? NavigationController{
            nav.backgroundLoading.isHidden = !isShow
            if isShow {
                nav.loading.startAnimating()
            }else {
                nav.loading.stopAnimating()
            }
        }
    }
    
    func setBackgroundImage(image:UIImage){
        tabBar.backgroundImage.image = image.withRenderingMode(.alwaysOriginal)
    }
    
    func setBackgroundImage(strURL:String){
        tabBar.backgroundImage.loadImage(strURL: strURL, fail: { (err) in
            print(err)
        })
    }
    
    func addShareButton(shareItem:ShareItem){
        self.shareItem = shareItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.actionShare))
    }
    
    func addNotifyButton(){
        let btn = UIBarButtonItem(image: #imageLiteral(resourceName: "notify").withRenderingMode(UIImageRenderingMode.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self.tabBarController, action: #selector(TabBarController.actionNotifyButton))
        btn.isEnabled = false
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func addSettingButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting").withRenderingMode(UIImageRenderingMode.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.actionSettingButton))
    }
    
    func addRefreshButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh").withRenderingMode(UIImageRenderingMode.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.actionRefreshButton))
    }
    
    func addMenuButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout").withRenderingMode(UIImageRenderingMode.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.actionMenu))
        self.navigationItem.leftBarButtonItem?.tintColor = .iconSelected
    }
    
    func actionRefreshButton(){
        
    }
    
    func actionSettingButton(){
        
    }
    
    func actionMenu(){
        
    }
    
    @objc private func actionShare(){
        let share = UIActivityViewController(activityItems: [self.shareItem.title, self.shareItem.image, self.shareItem.content, URL(string: self.shareItem.stringURL)!], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
}

class ShareItem{
    var title:String!
    var image:UIImage!
    var content:String!
    var stringURL:String!
}

