//
//  CinemaController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import RATreeView
import SwiftyUserDefaults

class CinemaController:BaseViewController{
    
    var listLocation: [Location] = []
    var listCinema: [Producer] = []
    var dropMenu: NavigationDropdownMenu!
    var treeView:RATreeView!
    var idLocation = ManagerUser.idLocation
    var minCinemaIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addRefreshButton()
        super.addNotifyButton()
        self.loadLocation()
    }
}

extension CinemaController:RATreeViewDelegate, RATreeViewDataSource{
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Producer {
            return item.listCinema!.count
        } else if let _ = item as? Cinema{
            return 0
        }else {
            return self.listCinema.count
        }
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Producer {
            return item.listCinema![index]
        } else {
            return listCinema[index]
        }
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        if let item = item as? Producer{
            let cell = treeView.dequeueReusableCell(withIdentifier: TreeCellProducer.identifier) as! TreeCellProducer
            cell.lblText.text = "Cụm Rạp \(item.name!)"
            cell.close = item.closeCell
            cell.selectionStyle = .none
            return cell
        }else if let item = item as? Cinema{
            let cell = treeView.dequeueReusableCell(withIdentifier: TreeCellCinema.identifier) as! TreeCellCinema
            cell.cinema = item
            cell.selectionStyle = .none
            return cell
        }
        assert(false, "Unexpected element cell")
    }
    
    func treeView(_ treeView: RATreeView, heightForRowForItem item: Any) -> CGFloat {
        if let _ = item as? Producer{
            return 50
        }else{
            return 60
        }
    }
    
    func treeView(_ treeView: RATreeView, willExpandRowForItem item: Any) {
        if let item = item as? Producer{
            if let i = listCinema.index(where: { ($0.id == item.id)}){
                listCinema[i].closeCell = false
                treeView.reloadRows(forItems: [item], with: RATreeViewRowAnimationNone)
            }
        }
    }
    
    func treeView(_ treeView: RATreeView, willCollapseRowForItem item: Any) {
        if let item = item as? Producer{
            if let i = listCinema.index(where: { ($0.id == item.id)}){
                listCinema[i].closeCell = true
                treeView.reloadRows(forItems: [item], with: RATreeViewRowAnimationNone)
            }
        }
    }
    
    func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
        if let item = item as? Cinema{
            let cinemaVC = DetailCinema()
            cinemaVC.listCinema = self.listCinema
            cinemaVC.cinema = item
            self.navigationController?.pushViewController(cinemaVC, animated: true)
        }
    }
    
    func treeView(_ treeView: RATreeView, canEditRowForItem item: Any) -> Bool {
        return false
    }
    
}

extension CinemaController{
    
    override func actionRefreshButton() {
        if !idLocation.isEmpty{
            loadCinema()
        }else{
            loadLocation()
        }
    }
    
    override func addSubView() {
        super.addSubView()
        treeView = RATreeView()
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: treeView)
        treeView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        treeView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        treeView.registerCells(TreeCellCinema.self, TreeCellProducer.self)
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = UIView()
        treeView.backgroundColor = UIColor.clear
        treeView.addShadow()
    }
    
    func loadCinema(addSubView:Bool = false){
        self.showLoading(isShow: true)
        ManagerData.share.getListCinema(idLocation: idLocation, success: { (list, total) in
            self.listCinema = list
            if self.listCinema.count < 1 {
                self.showLoading(isShow: false)
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
            }else{
                self.showLoading(isShow: false)
                if addSubView{
                    self.addSubView()
                }
                self.loadMapData(indexP: 0, indexC: 0, {
                    self.treeView.reloadData()
                })
                self.treeView.reloadData()
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
    
    func loadMapData(indexP: Int, indexC: Int, _ completion: @escaping () -> ()){
        if indexC == 0{
            self.minCinemaIndex = 0
        }
        if indexP < self.listCinema.count && indexC < (listCinema[indexP].listCinema?.count)!{
            self.listCinema[indexP].listCinema?[indexC].getMapData({ () in
                if indexC == 0{
                    self.listCinema[indexP].listCinema?[indexC].minDistance = true
                }
                if indexC == (self.listCinema[indexP].listCinema?.count)! - 1{
                    self.loadMapData(indexP: indexP + 1, indexC: 0, {
                        if let mapData = self.listCinema[indexP].listCinema?[indexC].mapData, self.minCinemaIndex < (self.listCinema[indexP].listCinema?.count)!, let minMapData = self.listCinema[indexP].listCinema?[self.minCinemaIndex].mapData, (mapData.routes?[0].legs?[0].distance?.value)! <= (minMapData.routes?[0].legs?[0].distance?.value)!{
                            self.listCinema[indexP].listCinema?[self.minCinemaIndex].minDistance = false
                            self.listCinema[indexP].listCinema?[indexC].minDistance = true
                            self.minCinemaIndex = indexC
                        }else{
                            self.listCinema[indexP].listCinema?[indexC].minDistance = false
                        }
                        completion()
                    })
                }else{
                    self.loadMapData(indexP: indexP, indexC: indexC + 1, {
                        if let mapData = self.listCinema[indexP].listCinema?[indexC].mapData, self.minCinemaIndex < (self.listCinema[indexP].listCinema?.count)!, let minMapData = self.listCinema[indexP].listCinema?[self.minCinemaIndex].mapData, (mapData.routes?[0].legs?[0].distance?.value)! <= (minMapData.routes?[0].legs?[0].distance?.value)!{
                            self.listCinema[indexP].listCinema?[self.minCinemaIndex].minDistance = false
                            self.listCinema[indexP].listCinema?[indexC].minDistance = true
                            self.minCinemaIndex = indexC
                        }else{
                            self.listCinema[indexP].listCinema?[indexC].minDistance = false
                        }
                        completion()
                    })
                }
            })
            
        }else{
            self.treeView.reloadData()
            completion()
        }
    }
    
    func loadLocation(){
        self.showLoading(isShow: true)
        ManagerData.share.getListLocation(success: { (list, total) in
            self.listLocation = list
            self.showLoading(isShow: false)
            if self.listLocation.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected, action: { (isOtherButton) in
                    if isOtherButton {
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
                    self.loadLocation()
                }
            }
            print(err)
        }
    }
    
    func setupDropMenu(){
        var index = 0
        var idLocation = "ha-noi"
        if !ManagerUser.idLocation.isEmpty{
            idLocation = ManagerUser.idLocation
        }
        if let i = listLocation.index(where: { ($0.id == idLocation)}){
            index = i
        }
        dropMenu = NavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, selectedIndex: index, items: listLocation)
        dropMenu.cellBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropMenu.cellSelectionColor = UIColor.iconSelected
        dropMenu.cellTextLabelColor = UIColor.iconSelected
        dropMenu.arrowTintColor = UIColor.icon
        dropMenu.selectedCellTextLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropMenu.cellTextLabelAlignment = .left
        dropMenu.arrowPadding = 15
        dropMenu.animationDuration = 0.5
        dropMenu.maskBackgroundOpacity = 0.3
        dropMenu.shouldKeepSelectedCellColor = true
        dropMenu.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.idLocation = self.listLocation[indexPath].id!
            self.loadCinema()
        }
        self.navigationItem.titleView = dropMenu
        if listLocation.count > index{
            self.idLocation = self.listLocation[index].id!
            self.loadCinema(addSubView: true)
        }
    }
}
