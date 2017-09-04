//
//  SettingController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import PageMenu
import SwiftyUserDefaults

class HomeController:BaseViewController{
    
    var listCinema:[Producer] = []
    var listDate:[String] = []
    var dropCinema: BTNavigationDropdownMenu!
    var pageMenu: CAPSPageMenu?
    var idCinema:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addRefreshButton()
        super.addNotifyButton()
        self.loadCinema()
    }
}

extension HomeController{
    
    override func actionRefreshButton() {
        super.actionRefreshButton()
        if idCinema != nil{
            loadDate(idCinema: idCinema)
        }else{
            loadCinema()
        }
    }
    
    func loadCinema(){
        self.showLoading(isShow: true)
        var idLocation = "ha-noi"
        if !ManagerUser.idLocation.isEmpty{
            idLocation = ManagerUser.idLocation
        }
        ManagerData.share.getListCinema(idLocation: idLocation, success: { (list, total) in
            self.listCinema = list
            self.showLoading(isShow: false)
            if self.listCinema.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
            }else{
                self.setupDropMenu()
            }
        }) { (error) in
            self.showLoading(isShow: false)
            alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                if !isOtherButton {
                    self.loadCinema()
                }
            }
        }
    }
    
    func loadDate(idCinema: String){
        self.showLoading(isShow: true)
        ManagerData.share.getListDateByCinema(idCinema: idCinema, success: { (list, total) in
            self.listDate = list
            self.showLoading(isShow: false)
            if list.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
            }else{
                self.setupPageMenu(idCinema: idCinema)
            }
        }) { (error) in
            self.showLoading(isShow: false)
            alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                if !isOtherButton {
                    self.loadDate(idCinema: idCinema)
                }
            }
        }
    }
    
    func setupDropMenu(){
        if listCinema.count > 0{
            self.idCinema = listCinema[0].listCinema?[0].id
        }
        var row = 0
        var section = 0
        if Defaults.hasKey(.cinema){
            for i in 0..<listCinema.count{
                for j in 0..<(listCinema[i].listCinema?.count)!{
                    if listCinema[i].listCinema?[j].id == Defaults[.cinema]{
                        self.idCinema = Defaults[.cinema]
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
            self.idCinema = self.listCinema[indexPath.section].listCinema?[indexPath.row].id
            Defaults[.cinema] = self.idCinema
            self.loadDate(idCinema: self.idCinema)
        }
        self.navigationItem.titleView = dropCinema
        self.loadDate(idCinema: idCinema)
    }
    
    func setupPageMenu(idCinema: String) {
        if pageMenu != nil{
            self.pageMenu?.view.removeFromSuperview()
        }
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
        var listPage:[TableSchedule] = []
        for date in listDate{
            let page = TableSchedule()
            page.title = date.toDate(stringFormat: "yyyy-MM-dd").toString(stringFormat: "dd/MM/yyyy")
            page.idCinema = idCinema
            page.date = date
            page.navigation = self.navigationController
            listPage.append(page)
        }
        if listPage.count > 0{
            listPage[0].loadData()
        }
        pageMenu = CAPSPageMenu(viewControllers: listPage, frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-113), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.view.addSubview((self.pageMenu?.view)!)
    }
    
}

extension HomeController:CAPSPageMenuDelegate{
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if (controller as! TableSchedule).listFilm.count <= 0{
            (controller as! TableSchedule).loadData()
        }
    }
}
