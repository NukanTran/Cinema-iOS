//
//  UserCtronller.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import SwiftyJSON
import FBSDKLoginKit
import GoogleSignIn
import SwiftyUserDefaults

class UserController:BaseViewController{
    
    let avatar:UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "avatar").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imv.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.clipsToBounds = true
        imv.layer.cornerRadius = 60
        imv.layer.borderColor = UIColor.iconSelected.cgColor
        imv.layer.borderWidth = 1
        imv.backgroundColor = UIColor.iconSelected
        imv.contentMode = .scaleAspectFill
        imv.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.5), shadowOffset: CGSize(width: 0, height: -2), shadowOpacity: 0.3, shadowRadius: 2)
        return imv
    }()
    
    let scrollView:UIScrollView = {
        let scv = UIScrollView()
        scv.clipsToBounds = true
        scv.layer.cornerRadius = 8
        scv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scv.layer.borderWidth = 1
        scv.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3015625).cgColor
//        scv.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.5), shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.5, shadowRadius: 2)
        return scv
    }()
    
    let textFieldUserName:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        tf.placeholder = "Email"
        tf.placeholderText = "Email đăng ký"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imv = UIImageView(image: #imageLiteral(resourceName: "username").withRenderingMode(.alwaysTemplate))
        imv.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imv.frame = CGRect(x: 10, y: 2, width: 16, height: 16)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        v.addSubview(imv)
        tf.leftViewMode = .always
        tf.keyboardType = .emailAddress
        tf.leftView = v
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 20
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.iconSelected.cgColor
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 90).isActive = true
        return tf
    }()
    
    let textFieldPassWorld:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        tf.placeholder = "Mật khẩu"
        tf.placeholderText = "Mật khẩu ít nhất 3 ký tự"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imv = UIImageView(image: #imageLiteral(resourceName: "pass").withRenderingMode(.alwaysTemplate))
        imv.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imv.frame = CGRect(x: 10, y: 2, width: 16, height: 16)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        v.addSubview(imv)
        tf.leftViewMode = .always
        tf.leftView = v
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 20
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.iconSelected.cgColor
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 90).isActive = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        self.addSubView()
        super.addSettingButton()
        super.addNotifyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = false
    }
}

extension UserController{
    override func addSubView() {
        super.addSubView()
        
        let btnLogin:UIButton = {
            let btn = UIButton()
            btn.setTitle("Đăng Nhập", for: .normal)
            btn.layer.cornerRadius = 20
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor.iconSelected
            btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
            btn.addTarget(self, action: #selector(UserController.login), for: .touchUpInside)
            return btn
        }()
        
        let btnSigin:UIButton = {
            let btn = UIButton()
            btn.setTitle("Đăng Ký", for: .normal)
            btn.layer.cornerRadius = 20
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 110).isActive = true
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor.icon
            btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
            btn.addTarget(self, action: #selector(UserController.register), for: .touchUpInside)
            return btn
        }()
        
        let btnFace:UIButton = {
            let btn = UIButton()
            btn.setTitle("Facebook", for: .normal)
            btn.layer.cornerRadius = 20
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor(hex: "#3b5998")
            let imv = UIImageView(image: #imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysTemplate))
            imv.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imv.frame = CGRect(x: 3, y: 3, width: 34, height: 34)
            btn.addSubview(imv)
            btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
            btn.addTarget(self, action: #selector(UserController.loginFacebook), for: .touchUpInside)
            return btn
        }()
        
        let btnGoogle:UIButton = {
            let btn = UIButton()
            btn.setTitle("Google+", for: .normal)
            btn.layer.cornerRadius = 20
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor(hex: "#dd4b39")
            let imv = UIImageView(image: #imageLiteral(resourceName: "google").withRenderingMode(.alwaysTemplate))
            imv.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imv.frame = CGRect(x: 3, y: 3, width: 34, height: 34)
            btn.addSubview(imv)
            btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
            btn.addTarget(self, action: #selector(UserController.loginGoogle), for: .touchUpInside)
            return btn
        }()
        
        let lblOr:UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.icon
            lbl.text = "Hoặc đăng nhập với?"
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont(name: AppConstants.FontName.italic, size: 12)
            lbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
            return lbl
        }()
        
        self.navigationItem.title = "Tài Khoản Người Dùng"
        self.view.addViewWithContrains(VSFormat: "H:|-15-[v0]-15-|", views: self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 82).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -15).isActive = true
        self.view.addViewWithContrains(VSFormat: "H:[v0(120)]", views: self.avatar)
        self.avatar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        self.avatar.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.avatar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: self.textFieldUserName)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]", views: self.textFieldPassWorld)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-3-[v1]-30-|", views: btnLogin, btnSigin)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: btnFace)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: btnGoogle)
        self.textFieldPassWorld.topAnchor.constraint(equalTo: self.textFieldUserName.bottomAnchor, constant: 3).isActive = true
        btnLogin.topAnchor.constraint(equalTo: self.textFieldPassWorld.bottomAnchor, constant: 15).isActive = true
        btnSigin.topAnchor.constraint(equalTo: self.textFieldPassWorld.bottomAnchor, constant: 15).isActive = true
        self.view.addSubview(lblOr)
        lblOr.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        if UIScreen.main.bounds.width < 350{
            self.textFieldUserName.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60).isActive = true
            lblOr.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 30).isActive = true
            btnGoogle.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -15).isActive = true
        }else if UIScreen.main.bounds.width < 380{
            self.textFieldUserName.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 75).isActive = true
            lblOr.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 60).isActive = true
            btnGoogle.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -30).isActive = true
        }else{
            self.textFieldUserName.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 75).isActive = true
            lblOr.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 100).isActive = true
            btnGoogle.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -30).isActive = true
        }
        btnFace.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
        btnGoogle.topAnchor.constraint(equalTo: btnFace.bottomAnchor, constant: 3).isActive = true
    }
    
    override func actionSettingButton() {
        let locationVC = LocationController()
        locationVC.btnClose.isHidden = false
        self.present(locationVC, animated: true, completion: nil)
    }
    
    func login(){
        self.view.endEditing(true)
        var err = ""
        if !(textFieldUserName.text?.isValidEmail())!{
            err += "Email không hợp lệ!\n"
        }
        if (textFieldPassWorld.text?.characters.count)! < 3{
            err += "Mật khẩu không hợp lệ!"
        }
        if err == ""{
            self.showLoading(isShow: true)
            ManagerData.share.login(email: textFieldUserName.text!, password: textFieldPassWorld.text!, success: { (user, total) in
                self.showLoading(isShow: false)
                _ = alert.showAlert("Thông Báo", subTitle: "Đăng nhập thành công", style: .success, buttonTitle: "OK", action: { (isOther) in
                    ManagerUser.user = user
                    (tabBar.viewControllers?[4] as! NavigationController).setViewControllers([UserLogin()], animated: true)
                    Defaults[.userName] = user.email!
                    Defaults[.password] = (self.textFieldPassWorld.text?.toBase64())!
                    AppConstants.userName = Defaults[.userName]
                    AppConstants.passwword = Defaults[.password]
                })
            }, fail: { (err) in
                self.showLoading(isShow: false)
                _ = alert.showAlert("Thông Báo", subTitle: err, style: .error)
            })
        }else{
            _ = alert.showAlert("Thông Báo", subTitle: err, style: .warning)
        }
    }
    
    func loginFacebook(){
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: {
            (result, error) in
            if error == nil {
                let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    print("Cancel")
                }else {
                    if fbLoginResult.grantedPermissions.contains("email") {
                        self.getFBLoginData()
                    }
                    
                }
            }else {
                _ = alert.showAlert("Thông Báo", subTitle: "Facebook login error\n\(error!)" , style: .error)
                print("Facebook login error: \(error!)")
            }
        })
    }
    
    func loginGoogle(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    func register(){
        self.view.isHidden = true
        let register = RegisterUser()
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    func getFBLoginData() {
        if FBSDKAccessToken.current() != nil {
            self.showLoading(isShow: true)
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, email, name, picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                if error == nil {
                    let data = JSON(result as! [String : Any])
                    print("*******FBLogin*******\n\(data)")
                    let loginData = FacebookLoginData(json: data)
                    ManagerData.share.login(email: loginData.email ?? loginData.id!, password: AppConstants.cryptoKey128, success: { (user, total) in
                        self.showLoading(isShow: false)
                        ManagerUser.user = user
                        tabBar.user.setViewControllers([UserLogin()], animated: true)
                        Defaults[.userName] = loginData.email ?? loginData.id!
                        Defaults[.password] = (AppConstants.cryptoKey128.toBase64())!
                    }, fail: { (err) in
                        let user = User()
                        user.email = loginData.email ?? loginData.id!
                        user.name = loginData.name
                        user.linkAvatar = loginData.picture?.data?.url
                        user.password = AppConstants.cryptoKey128.toBase64()
                        ManagerData.share.register(user: user, success: {
                            self.showLoading(isShow: false)
                            user.listFilm = []
                            user.listCinema = []
                            user.listEvent = []
                            ManagerUser.user = user
                            (tabBar.viewControllers?[4] as! NavigationController).setViewControllers([UserLogin()], animated: true)
                            Defaults[.userName] = user.email!
                            Defaults[.password] = (AppConstants.cryptoKey128.toBase64())!
                        }, fail: { (err) in
                            self.showLoading(isShow: false)
                            _ = alert.showAlert("Thông Báo", subTitle: err, style: .error)
                        })
                    })
                }else {
                    self.showLoading(isShow: false)
                    _ = alert.showAlert("Thông Báo", subTitle: error.debugDescription , style: .error)
                    print(error ?? "")
                }
            })
        }
        
    }
}

extension UserController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("error \(error.localizedDescription)")
            return
        }else {
            self.showLoading(isShow: true)
            ManagerData.share.login(email: user.profile.email ?? user.userID!, password: AppConstants.cryptoKey128, success: { (userData, total) in
                self.showLoading(isShow: false)
                ManagerUser.user = userData
                tabBar.user.setViewControllers([UserLogin()], animated: true)
                Defaults[.userName] = user.profile.email ?? user.userID!
                Defaults[.password] = (AppConstants.cryptoKey128.toBase64())!
            }, fail: { (err) in
                let userData = User()
                userData.email = user.profile.email ?? user.userID!
                userData.name = user.profile.name
                userData.linkAvatar = user.profile.imageURL(withDimension: 250).absoluteString
                userData.password = AppConstants.cryptoKey128.toBase64()
                ManagerData.share.register(user: userData, success: {
                    self.showLoading(isShow: false)
                    userData.listFilm = []
                    userData.listCinema = []
                    userData.listEvent = []
                    ManagerUser.user = userData
                    (tabBar.viewControllers?[4] as! NavigationController).setViewControllers([UserLogin()], animated: true)
                    Defaults[.userName] = userData.email!
                    Defaults[.password] = (AppConstants.cryptoKey128.toBase64())!
                }, fail: { (err) in
                    self.showLoading(isShow: false)
                    _ = alert.showAlert("Thông Báo", subTitle: err, style: .error)
                })
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dimiss")
        self.dismiss(animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("diddisconnect")
    }
    
    func autoLoginGoogle() {
        GIDSignIn.sharedInstance().signInSilently()
    }
}
