//
//  DetailCinema.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/3/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import PageMenu

class DetailCinema:BaseDetailController{
    
    var dropCinema: BTNavigationDropdownMenu!
    var pageMenu: CAPSPageMenu?
    let map = CinemaMaps()
    let info = CinemaInfo()
    var listCinema:[Producer]!
    var cinema:Cinema!{
        didSet{
            self.setupShareButton()
            self.listImage = [cinema.linkImage!]
            self.setBackgroundImage(strURL: cinema.linkImage!)
            self.imvBanner.loadImage(strURL: cinema.linkImage, success: { (image) in
                let shareItem = ShareItem()
                shareItem.title = self.cinema.name
                shareItem.content = self.cinema.intro
                shareItem.stringURL = "\(AppConstants.HOST)detailcinema.aspx?id=\(self.cinema.id!)"
                shareItem.image = image
                self.addShareButton(shareItem: shareItem)
            }) { (err) in
                print(err)
            }
            self.textBanner = cinema.address!
            map.cinema = self.cinema
            info.lblPhoneNumber.text = "Điện thoại : \(self.cinema.phoneNumber!)"
            info.lblAddress.text =     "Địa chỉ : \(self.cinema.address!)"
            info.lblIntro.text = self.cinema.intro
            self.tableView.reloadData()
//            if ManagerUser.user.isLikeCinema(id: cinema.id!){
//                self.btnHeart.select()
//            }else{
//                self.btnHeart.deselect()
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if listCinema != nil{
            self.setupDropMenu()
        }else{
            self.setTitle(title: cinema.name!)
            self.showLoading(isShow: true)
            self.cinema.getMapData({ 
                self.showLoading(isShow: false)
                self.map.polyLine()
                self.map.marker(cinema: self.cinema, title: "")
            })
        }
        self.setupPageMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = ManagerUser.user, user.isLikeCinema(id: cinema.id!){
            self.btnHeart.select()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if dropCinema != nil{
            self.dropCinema.hideMenu()
        }
    }
    
    override func actionLike(sender: DOFavoriteButton) {
        if let user = ManagerUser.user{
            sender.isEnabled = false
            if !user.isLikeCinema(id: cinema.id!) {
                sender.select()
                ManagerData.share.like(email: user.email!, id: cinema.id!, categorie: "cinema", success: {
                    sender.isEnabled = true
                    user.listCinema?.append(self.cinema)
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            } else {
                sender.deselect()
                ManagerData.share.unlike(email: user.email!, id: cinema.id!, categorie: "cinema", success: {
                    sender.isEnabled = true
                    user.listCinema = user.listCinema?.filter{$0.id != self.cinema.id}
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            }
        }
    }
}

extension DetailCinema{
    
    func setupDropMenu(){
        var section = 0
        var row = 0
        for i in 0..<listCinema.count{
            if let list = listCinema[i].listCinema{
                for j in 0..<list.count{
                    if list[j].id == cinema.id{
                        section = i
                        row = j
                        break
                    }
                }
            }
        }
        dropCinema = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, selectedIndex: IndexPath(row: row, section: section), items: listCinema)
        dropCinema.cellBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropCinema.cellSelectionColor = UIColor.iconSelected
        dropCinema.cellTextLabelColor = UIColor.iconSelected
        dropCinema.arrowTintColor = UIColor.icon
        dropCinema.selectedCellTextLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropCinema.cellTextLabelAlignment = .left
        dropCinema.arrowPadding = 15
        dropCinema.animationDuration = 0.5
        dropCinema.maskBackgroundOpacity = 0.3
        dropCinema.shouldKeepSelectedCellColor = true
        dropCinema.didSelectItemAtIndexHandler = {(indexPath: IndexPath) -> () in
            self.cinema = self.listCinema[indexPath.section].listCinema?[indexPath.row]
            self.tableView.reloadData()
        }
        self.navigationItem.titleView = dropCinema
    }
    
    func setupPageMenu() {
        if self.pageMenu != nil{
            self.pageMenu?.view.removeFromSuperview()
        }
        self.heightContent = UIScreen.main.bounds.height - 113 - 40
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.7)),
            .viewBackgroundColor(UIColor.clear),
            .bottomMenuHairlineColor(UIColor.clear),
            .selectionIndicatorColor(UIColor.iconSelected),
            .selectedMenuItemLabelColor(UIColor.iconSelected),
            .unselectedMenuItemLabelColor(UIColor.icon),
            .menuItemFont(UIFont(name: AppConstants.FontName.semibold, size: 15.0)!)
        ]
        map.title = "Bản Đồ"
        map.view.backgroundColor = UIColor.clear
        map.listCinema = self.listCinema
        map.cinema = cinema
        info.title = "Thông Tin"
        info.lblPhoneNumber.text = "Điện thoại : \(self.cinema.phoneNumber!)"
        info.lblAddress.text =     "Địa chỉ : \(self.cinema.address!)"
        info.lblIntro.text = self.cinema.intro
        info.view.backgroundColor = UIColor.clear
        pageMenu = CAPSPageMenu(viewControllers: [map, info], frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: heightContent), pageMenuOptions: parameters)
        self.viewContent.addSubview((self.pageMenu?.view)!)
    }
    
    func setupShareButton(){
        let shareItem = ShareItem()
        shareItem.title = self.cinema.name
        shareItem.content = self.cinema.intro
        shareItem.stringURL = "\(AppConstants.HOST)detailcinema.aspx?id=\(self.cinema.id!)"
        UIImageView().loadImage(strURL: self.cinema.linkImage, success: { (image) in
            shareItem.image = image
            self.addShareButton(shareItem: shareItem)
        }) { (err) in
            print(err)
        }
    }
}
