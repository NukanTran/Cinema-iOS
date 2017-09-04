//
//  ScheduleFilmController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/6/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import PageMenu
import SwiftyUserDefaults

class ScheduleFilm:BaseDetailController{
    
    var listCinema:[Producer] = []
    var listSchedule:[[Schedule]] = []
    var loading = false
    var dropCinema: BTNavigationDropdownMenu!
    var pageMenu: CAPSPageMenu!
    
    var film:Film!{
        didSet{
            self.listImage = [film.linkBanner!, film.linkPoster!]
            self.textBanner = film.name!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShareButton()
        loadCinema()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if dropCinema != nil{
            self.dropCinema.hideMenu()
        }
    }
    
}

extension ScheduleFilm{
    
    func loadCinema(){
        self.showLoading(isShow: true)
        var idLocation = "ha-noi"
        if !ManagerUser.idLocation.isEmpty{
            idLocation = ManagerUser.idLocation
        }
        ManagerData.share.getListCinemaByFilm(idLocation: idLocation, idFilm: film.id!, success: { (list, total) in
            self.listCinema = list
            if self.listCinema.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có lịch chiếu ở khu vực của bạn!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected, action: { (isOtherButton) in
                    if isOtherButton {
                        self.showLoading(isShow: false)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }else{
                self.setupDropMenu()
            }
        }) { (err) in
            self.showLoading(isShow: false)
            alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                if !isOtherButton {
                    self.loadCinema()
                }
            }
        }
    }
    
    func loadSchedule(idCinema:String){
        if !loading{
            self.loading = true
            self.showLoading(isShow: true)
            ManagerData.share.getListSchedule(idFilm: film.id!, idCinema: idCinema, success: { (list, total) in
                self.loading = false
                self.showLoading(isShow: false)
                if let user = ManagerUser.user, user.isLikeFilm(id: self.film.id!){
                    self.btnHeart.select()
                }
                if list.count < 1 {
                    _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
                }else{
                    self.listSchedule = []
                    var listSchedule:[Schedule] = []
                    listSchedule.append(list[0])
                    for i in 1..<list.count{
                        if list[i-1].date.toString(stringFormat: "dd/MM/yyyy") == list[i].date.toString(stringFormat: "dd/MM/yyyy"){
                            listSchedule.append(list[i])
                        }else{
                            self.listSchedule.append(listSchedule)
                            listSchedule = []
                            listSchedule.append(list[i])
                        }
                    }
                    self.listSchedule.append(listSchedule)
                    self.setupPageMenu()
                }
            }, fail: { (err) in
                self.loading = false
                self.showLoading(isShow: false)
                alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                    if !isOtherButton {
                        self.loadSchedule(idCinema: idCinema)
                    }
                }
            })
        }
    }
    
    func setupDropMenu(){
        var idCinema = ""
        if listCinema.count > 0{
            idCinema = (listCinema[0].listCinema?[0].id!)!
        }
        var row = 0
        var section = 0
        if Defaults.hasKey(.cinema){
            for i in 0..<listCinema.count{
                for j in 0..<(listCinema[i].listCinema?.count)!{
                    if listCinema[i].listCinema?[j].id == Defaults[.cinema]{
                        idCinema = Defaults[.cinema]
                        row = j
                        section = i
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
            self.loadSchedule(idCinema: (self.listCinema[indexPath.section].listCinema?[indexPath.row].id!)!)
        }
        self.navigationItem.titleView = dropCinema
        if !idCinema.isEmpty{
            loadSchedule(idCinema: idCinema)
        }
    }
    
    func setupPageMenu() {
        if pageMenu != nil{
            self.pageMenu?.view.removeFromSuperview()
        }
        heightContent = UIScreen.main.bounds.height - UIScreen.main.bounds.width*2/3 - 113
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
        var listPage:[CollectionScheduleFilm] = []
        for listSH in self.listSchedule{
            let page = CollectionScheduleFilm()
            page.title = listSH[0].date.toString(stringFormat: "dd/MM/yyyy")
            page.listSchedule = listSH
            page.navigation = self.navigationController
            let h = CGFloat(Int((CGFloat(listSH.count)/CGFloat(Int((UIScreen.main.bounds.width-24)/108)) + 0.99)))*58 + 62
            if h > heightContent{
                heightContent = h
            }
            listPage.append(page)
        }
        pageMenu = CAPSPageMenu(viewControllers: listPage, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: heightContent), pageMenuOptions: parameters)
        self.viewContent.addSubview((self.pageMenu?.view)!)
        self.tableView.reloadData()
    }
    
    func setupShareButton(){
        let shareItem = ShareItem()
        shareItem.title = self.film.name
        shareItem.content = self.film.intro
        shareItem.stringURL = "\(AppConstants.HOST)filmschedule.aspx?id=\(self.film.id!)"
        UIImageView().loadImage(strURL: self.film.linkBanner, success: { (image) in
            shareItem.image = image
            self.addShareButton(shareItem: shareItem)
        }) { (err) in
            print(err)
        }
    }
    
    override func actionLike(sender: DOFavoriteButton) {
        if let user = ManagerUser.user{
            sender.isEnabled = false
            if !user.isLikeFilm(id: film.id!) {
                sender.select()
                ManagerData.share.like(email: user.email!, id: film.id!, categorie: "film", success: {
                    sender.isEnabled = true
                    user.listFilm?.append(self.film)
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            } else {
                sender.deselect()
                ManagerData.share.unlike(email: user.email!, id: film.id!, categorie: "film", success: {
                    sender.isEnabled = true
                    user.listFilm = user.listFilm?.filter{$0.id != self.film.id}
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            }
        }
        
    }
}
