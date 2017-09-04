//
//  TabBarController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/6/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import SwiftyUserDefaults

class TabBarController:ESTabBarController{
    
    let backgroundImage:UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "background")
        imv.layer.zPosition = -10
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFill
        let vse = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        imv.addViewWithContrains(VSFormat: "H:|[v0]|", views: vse)
        imv.addViewWithContrains(VSFormat: "V:|[v0]|", views: vse)
        return imv
    }()
    
    let avatar:UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "home").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imv.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.clipsToBounds = true
        imv.layer.cornerRadius = 26
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
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
        view.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 25).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loading.hidesWhenStopped = true
        return loading
    }()
    
    let event = NavigationController(rootViewController: EventController())
    let film = NavigationController(rootViewController: FilmController())
    let home = NavigationController(rootViewController: HomeController())
    let user = NavigationController(rootViewController: UserController())
    let cinema = NavigationController(rootViewController: CinemaController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Defaults.removeAll()
        self.login()
        UISegmentedControl.appearance().setTitleTextAttributes(NSDictionary(object: UIFont(name: AppConstants.FontName.semibold, size: 16.0)!, forKey: NSFontAttributeName as NSCopying) as [NSObject : AnyObject] , for: .normal)
        self.addBackgroundImage(image: #imageLiteral(resourceName: "background").withRenderingMode(.alwaysOriginal))
        self.addLoading()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension TabBarController{
    
    func login(){
        if !AppConstants.userName.isEmpty{
            let userLogin = UserLogin()
            self.showLoading(isShow: true)
            user.setViewControllers([userLogin], animated: true)
            self.tabBar.isHidden = true
            ManagerData.share.login(email: AppConstants.userName, password: AppConstants.passwword.base64ToString()!, success: { (user, total) in
                self.tabBar.isHidden = false
                self.addViewController()
                self.showLoading(isShow: false)
                ManagerUser.user = user
                userLogin.user = user
            }, fail: { (err) in
                self.tabBar.isHidden = false
                self.showLoading(isShow: false)
                self.addViewController()
                self.user.setViewControllers([UserController()], animated: true)
            })
        }else{
            addViewController()
        }
    }
    
    func addViewController(){
        event.tabBarItem = ESTabBarItem.init(TabBarItem(), title: nil, image: #imageLiteral(resourceName: "event"), selectedImage: #imageLiteral(resourceName: "event_select"))
        film.tabBarItem = ESTabBarItem.init(TabBarItem(), title: nil, image: #imageLiteral(resourceName: "film"), selectedImage: #imageLiteral(resourceName: "film_select"))
        home.tabBarItem = ESTabBarItem.init(TabBarItemForUser(frame: CGRect.zero, avatar: self.avatar), title: "", image: nil, selectedImage: nil)
        cinema.tabBarItem = ESTabBarItem.init(TabBarItem(), title: nil, image: #imageLiteral(resourceName: "location"), selectedImage: #imageLiteral(resourceName: "location_select"))
        user.tabBarItem = ESTabBarItem.init(TabBarItem(), title: nil, image: #imageLiteral(resourceName: "user"), selectedImage: #imageLiteral(resourceName: "user_select"))
        
        self.viewControllers = [event, film, home, cinema, user]
        self.selectedIndex = 2
//        if let tabBarItem = event.tabBarItem as? ESTabBarItem {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 30 ) {
//                tabBarItem.badgeValue = "99+"
//            }
//        }
    }
    
    func addBackgroundImage(image:UIImage){
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.backgroundImage)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]|", views: self.backgroundImage)
        self.backgroundImage.image = image
    }
    
    func actionNotifyButton(){
        print("Nofity")
    }
    
    func addLoading() {
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: backgroundLoading)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]|", views: backgroundLoading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "H:|[v0]|", views: loading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "V:|[v0]-49-|", views: loading)
    }
    
    func showLoading(isShow: Bool) {
        backgroundLoading.isHidden = !isShow
        if isShow {
            loading.startAnimating()
        }else {
            loading.stopAnimating()
        }
    }
}




