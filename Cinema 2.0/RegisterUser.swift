//
//  RegisterUser.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 5/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class RegisterUser:BaseViewController{
    
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
    
    let textFieldEmail:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        tf.placeholder = "Email"
        tf.placeholderText = "Email đăng ký"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imv = UIImageView(image: #imageLiteral(resourceName: "email").withRenderingMode(.alwaysTemplate))
        imv.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imv.frame = CGRect(x: 10, y: 2, width: 16, height: 16)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        v.addSubview(imv)
        tf.keyboardType = .emailAddress
        tf.leftViewMode = .always
        tf.leftView = v
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 20
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.iconSelected.cgColor
        tf.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 90).isActive = true
        return tf
    }()
    
    let textFieldPhone:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        tf.placeholder = "Số điện thoại"
        tf.placeholderText = "Số điện thoại đăng ký"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imv = UIImageView(image: #imageLiteral(resourceName: "phone").withRenderingMode(.alwaysTemplate))
        imv.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imv.frame = CGRect(x: 10, y: 2, width: 16, height: 16)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        v.addSubview(imv)
        tf.keyboardType = .phonePad
        tf.leftViewMode = .always
        tf.leftView = v
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 20
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.iconSelected.cgColor
        tf.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 90).isActive = true
        return tf
    }()
    
    let textFieldName:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        tf.placeholder = "Tên hiển thị"
        //        tf.placeholderText = "Số điện thoại đăng ký"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imv = UIImageView(image: #imageLiteral(resourceName: "username").withRenderingMode(.alwaysTemplate))
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
        tf.layer.borderColor = UIColor.iconSelected.cgColor
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
        tf.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 90).isActive = true
        return tf
    }()
    
    let textFieldCFPassWorld:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        tf.placeholder = "Nhập lại mật khẩu"
        tf.placeholderText = "Nhập lại mật khẩu"
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
        tf.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 90).isActive = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubView()
        super.addNotifyButton()
    }
}

extension RegisterUser{
    override func addSubView() {
        super.addSubView()
        let btnSigin:UIButton = {
            let btn = UIButton()
            btn.setTitle("Đăng Ký", for: .normal)
            btn.layer.cornerRadius = 20
            btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btn.clipsToBounds = true
            btn.backgroundColor = UIColor.icon
            btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
            btn.addTarget(self, action: #selector(UserController.register), for: .touchUpInside)
            return btn
        }()
        
        self.navigationItem.title = "Đăng Ký Tài Khoản"
        self.view.addViewWithContrains(VSFormat: "H:|-15-[v0]-15-|", views: self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 82).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -15).isActive = true
        self.view.addViewWithContrains(VSFormat: "H:[v0(120)]", views: self.avatar)
        self.avatar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        self.avatar.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.avatar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: self.textFieldEmail)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: self.textFieldPhone)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: self.textFieldName)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]", views: self.textFieldPassWorld)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-30-[v0]-30-|", views: self.textFieldCFPassWorld)
        self.scrollView.addViewWithContrains(VSFormat: "H:|-50-[v0]-50-|", views: btnSigin)
        self.scrollView.addViewWithContrains(VSFormat: "V:[v0(40)]-3-[v1(40)]-3-[v2(40)]-3-[v3(40)]-3-[v4(40)]-20-[v5(40)]-20-|", views: textFieldEmail, textFieldPhone, textFieldName, textFieldPassWorld, textFieldCFPassWorld, btnSigin)
        if UIScreen.main.bounds.width < 350{
            self.textFieldEmail.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60).isActive = true
        }else{
            self.textFieldEmail.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 75).isActive = true
        }
    }
    
    func register(){
        self.view.endEditing(true)
        var err = ""
        if !(textFieldEmail.text?.isValidEmail())!{
            err += "Email không hợp lệ!\n"
        }
        if (textFieldName.text?.isEmpty)!{
            err += "Tên hiển thị trống!\n"
        }
        if (textFieldPassWorld.text?.characters.count)! < 3{
            err += "Mật khẩu không hợp lệ!\n"
        }
        if textFieldPassWorld.text != textFieldCFPassWorld.text{
            err += "Mật khẩu nhập lại không chính xác!"
        }
        if err == ""{
            self.showLoading(isShow: true)
            let user = User()
            user.email = textFieldEmail.text!
            user.name = textFieldName.text!
            user.phoneNumber = textFieldPhone.text!
            user.password = textFieldPassWorld.text!.toBase64()
            ManagerData.share.register(user: user, success: {
                self.showLoading(isShow: false)
                _ = alert.showAlert("Thông Báo", subTitle: "Đã đăng ký tài khoản", style: .success, buttonTitle: "OK", action: { (isOther) in
                    user.listFilm = []
                    user.listCinema = []
                    user.listEvent = []
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
}
