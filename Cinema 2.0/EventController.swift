//
//  EventController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import PageMenu

class EventController:BaseViewController{
    
    var listProducer:[Producer] = []
    var pageMenu: CAPSPageMenu?
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addRefreshButton()
        super.addNotifyButton()
        self.loadData()
        self.addSubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tableView = self.tableView{
            tableView.reloadData()
        }
    }
    
    override func addSubView() {
        self.navigationItem.title = "Sự Kiện Khuyến Mãi"
        self.navigationItem.titleView?.tintColor = UIColor.iconSelected
    }
    
    override func actionRefreshButton() {
        self.loadData()
    }
    
}

extension EventController{
    
    override func loadData() {
        self.showLoading(isShow: true)
        ManagerData.share.getListProducer(success: { (listLocal, total) in
            self.listProducer = listLocal
            if self.listProducer.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
            }else{
                self.setupPageMenu()
            }
        }) { (error) in
            self.showLoading(isShow: false)
            alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                if !isOtherButton {
                    self.loadData()
                }
            }
        }
    }
    
    func setupPageMenu() {
//        if let i = self.listProducer.index(where: {$0.id == "5"}){
//            self.listProducer.remove(at: i)
//        }
        if self.pageMenu != nil{
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
        var listPage:[TableViewEvent] = []
        for producer in listProducer{
            let page : TableViewEvent = TableViewEvent(style: .plain, idProducer: producer.id!)
            page.title = producer.name
            page.parentNavigationController = self.navigationController
            listPage.append(page)
        }
        if listPage.count > 0{
            self.tableView = listPage[0].tableView
            listPage[0].loadData()
        }
        pageMenu = CAPSPageMenu(viewControllers: listPage, frame: CGRect(x: 0, y: self.topLayoutGuide.length, width: self.view.frame.width, height: self.view.frame.height-113), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.view.addSubview((self.pageMenu?.view)!)
    }
    
}

extension EventController:CAPSPageMenuDelegate{
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        self.tableView = (controller as! TableViewEvent).tableView
        if (controller as! TableViewEvent).listEvent.count <= 0{
            (controller as! TableViewEvent).loadData()
        }
    }
}
