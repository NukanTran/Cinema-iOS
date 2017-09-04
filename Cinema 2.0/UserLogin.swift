//
//  UserLogin.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 5/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import Popover
import SwiftyUserDefaults

class UserLogin:BaseViewController{
    
    let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
    
    var user:User!{
        didSet{
            if let user = self.user{
                self.tbvUser.reloadData()
                self.lblName.text = user.name
                self.lblEmail.text = "Email : " + user.email!
                if let phoneNumber = user.phoneNumber{
                    self.lblPhone.text = "Phone : " + phoneNumber
                }else{
                    self.lblPhone.text = "Phone : ----.---.---"
                }
                if let linkAvatar = user.linkAvatar{
                    self.avatar.loadImage(strURL: linkAvatar, fail: { (err) in
                        print(err)
                    })
                }
            }
        }
    }
    
    let listHeader = ["Cài đặt", "Phim yêu thích", "Rạp yêu thích", "Khuyến mãi yêu thích"]
    
    lazy var tbvUser:UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = UIColor.clear
        tbv.registerCells(UITableViewCell.self)
        tbv.registerHeaderFooters(TableHeaderUser.self)
        tbv.delegate = self
        tbv.dataSource = self
        return tbv
    }()
    
    let imvBanner:UIImageView = {
        let imv = UIImageView()
        imv.backgroundColor = UIColor.icon.withAlphaComponent(0.7)
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    let lblName:MarqueeLabel = {
        let lbl = MarqueeLabel()
        lbl.font = UIFont(name: AppConstants.FontName.semibold, size: 20)
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return lbl
    }()
    
    let lblEmail:MarqueeLabel = {
        let lbl = MarqueeLabel()
        lbl.font = UIFont(name: AppConstants.FontName.regular, size: 14)
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return lbl
    }()
    
    let lblPhone:MarqueeLabel = {
        let lbl = MarqueeLabel()
        lbl.font = UIFont(name: AppConstants.FontName.regular, size: 14)
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return lbl
    }()
    
    let avatar:UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "avatar").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imv.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imv.layer.cornerRadius = (UIScreen.main.bounds.width/2 - 94)/2
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.clipsToBounds = true
        imv.layer.borderColor = UIColor.iconSelected.cgColor
        imv.layer.borderWidth = 2
        imv.backgroundColor = UIColor.iconSelected
        imv.contentMode = .scaleAspectFill
        //imv.addShadow(shadowColor: UIColor.white.withAlphaComponent(0.5), shadowOffset: CGSize(width: 0, height: -2), shadowOpacity: 0.3, shadowRadius: 2)
        return imv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addNotifyButton()
        super.addMenuButton()
        self.addSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = false
        if let user = ManagerUser.user{
            self.user = user
        }
    }
}

extension UserLogin{
    override func addSubView() {
        self.navigationItem.title = "Tài Khoản Người Dùng"
        self.imvBanner.addViewWithContrains(VSFormat: "H:|-15-[v0]-8-[v1]", views: self.avatar, self.lblName)
        self.imvBanner.addViewWithContrains(VSFormat: "V:|-15-[v0]-15-|", views: self.avatar)
        self.imvBanner.addViewWithContrains(VSFormat: "V:|-15-[v0]-3-[v1]-3-[v2]", views: self.lblName, self.lblEmail, self.lblPhone)
        self.lblEmail.leftAnchor.constraint(equalTo: self.lblName.leftAnchor).isActive = true
        self.lblEmail.rightAnchor.constraint(equalTo: self.imvBanner.rightAnchor, constant: -8).isActive = true
        self.lblPhone.leftAnchor.constraint(equalTo: self.lblName.leftAnchor).isActive = true
        self.lblPhone.rightAnchor.constraint(equalTo: self.imvBanner.rightAnchor, constant: -8).isActive = true
        self.avatar.widthAnchor.constraint(equalTo: self.avatar.heightAnchor).isActive = true
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.tbvUser)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.imvBanner)
        self.imvBanner.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.view.addViewWithContrains(VSFormat: "V:[v0(\(UIScreen.main.bounds.width/2 - 64))][v1]", views: self.imvBanner, self.tbvUser)
        self.tbvUser.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.backgroundAlpha
        refreshControl.attributedTitle = NSAttributedString(string: "Cập nhật dữ liệu", attributes: [NSForegroundColorAttributeName : UIColor.text, NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        refreshControl.tintColor = UIColor.text
        refreshControl.addTarget(self, action: #selector(TableViewEvent.refreshData), for: UIControlEvents.valueChanged)
        self.tbvUser.addSubview(refreshControl)
        self.tbvUser.reloadData()
    }
    
    func refreshData(sender: UIRefreshControl){
        sender.endRefreshing()
        if !AppConstants.userName.isEmpty{
            self.showLoading(isShow: true)
            ManagerData.share.login(email: AppConstants.userName, password: AppConstants.passwword.base64ToString()!, success: { (user, total) in
                self.showLoading(isShow: false)
                ManagerUser.user = user
                self.user = user
            }, fail: { (err) in
                self.showLoading(isShow: false)
            })
        }
    }
    
    override func actionMenu() {        
        let startPoint = CGPoint(x: 27, y: 55)
        let menu = ViewMenu(frame: CGRect(x: 3, y: 0, width: 300, height: 166))
        menu.closeAction = menuSelect(i:)
        menu.layer.zPosition = 1000
        menu.alpha = 1
        popover.show(menu, point: startPoint)
    }
    
    func menuSelect(i:Int){
        self.popover.dismiss()
        switch i {
        case 0:
            alert.showChangePassword(user: self.user)
            break
        case 1:
            self.view.isHidden = true
            let register = RegisterUser()
            self.navigationController?.pushViewController(register, animated: true)
            break
        case 2:
            _ = alert.showAlert("Thông Báo", subTitle: "Bạn muốn đăng xuất tài khoản?", style: .error, buttonTitle: "Có", buttonColor: UIColor.iconSelected, otherButtonTitle: "Không", otherButtonColor: UIColor.orange) { (isOther) in
                if isOther{
                    let al = SweetAlert()
                    _ = al.showAlert("Thông Báo", subTitle: "Đã đăng xuất tài khoản", style: .success, buttonTitle: "OK", action: { (isOther) in
                        ManagerUser.user = nil
                        Defaults.removeAll()
                        (tabBar.viewControllers?[4] as! NavigationController).setViewControllers([UserController()], animated: false)
                    })
                }
            }
            break
        default:
            break
        }
    }
}


extension UserLogin:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = self.user{
            switch section {
            case 0:
                return 0
            case 1:
                if let list = user.listFilm{
                    return list.count
                }
                return 0
            case 2:
                if let list = user.listCinema{
                    return list.count
                }
                return 0
            default:
                if let list = user.listEvent{
                    return list.count
                }
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        switch indexPath.section {
        case 1:
            cell.textLabel?.text = "  " + (user.listFilm?[indexPath.row].name)!
            break
        case 2:
            cell.textLabel?.text = "  " + (user.listCinema?[indexPath.row].name)!
            break
        default:
            cell.textLabel?.text = "  " + (user.listEvent?[indexPath.row].name)!
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderUser.identifier) as! TableHeaderUser
        header.lblText.text = listHeader[section]
        header.menuArrow.isHidden = true
        switch section {
        case 0:
            header.imvIcon.image = #imageLiteral(resourceName: "setting").withRenderingMode(.alwaysTemplate)
            header.menuArrow.isHidden = false
            header.actionSetting = {
                let locationVC = LocationController()
                locationVC.btnClose.isHidden = false
                self.present(locationVC, animated: true, completion: nil)
            }
            break
        case 1:
            header.imvIcon.image = #imageLiteral(resourceName: "film_select").withRenderingMode(.alwaysTemplate)
            header.actionSetting = nil
            break
        case 2:
            header.imvIcon.image = #imageLiteral(resourceName: "location_select").withRenderingMode(.alwaysTemplate)
            header.actionSetting = nil
            break
        default:
            header.imvIcon.image = #imageLiteral(resourceName: "event_select").withRenderingMode(.alwaysTemplate)
            header.actionSetting = nil
            break
        }
        return header as UIView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == listHeader.count - 1{
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            switch indexPath.section {
            case 1:
                ManagerData.share.unlike(email: self.user.email!, id: (user.listFilm?[indexPath.row].id!)!, categorie: "film", success: {
                }, fail: { (err) in
                    print(err)
                })
                user.listFilm?.remove(at: indexPath.row)
                break
            case 2:
                ManagerData.share.unlike(email: self.user.email!, id: (user.listCinema?[indexPath.row].id!)!, categorie: "cinema", success: {
                }, fail: { (err) in
                    print(err)
                })
                user.listCinema?.remove(at: indexPath.row)
                break
            case 3:
                ManagerData.share.unlike(email: self.user.email!, id: (user.listEvent?[indexPath.row].id!)!, categorie: "event"
                    , success: {
                }, fail: { (err) in
                    print(err)
                })
                user.listEvent?.remove(at: indexPath.row)
                break
            default:
                break
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            let film = ScheduleFilm()
            film.film = user.listFilm?[indexPath.row]
            self.navigationController?.pushViewController(film, animated: true)
            break
        case 2:
            let cinema = DetailCinema()
            cinema.cinema = user.listCinema?[indexPath.row]
            self.navigationController?.pushViewController(cinema, animated: true)
            break
        default:
            let event = DetailEventController()
            event.event = user.listEvent?[indexPath.row]
            self.navigationController?.pushViewController(event, animated: true)
            break
        }
        
        
    }
}
