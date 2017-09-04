//
//  ScheduleController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/30/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import FoldingCell

class TableSchedule:UIViewController{

    var idCinema:String?
    var date:String?
    var listFilm:[Film] = []
    let kCloseCellHeight: CGFloat = (UIScreen.main.bounds.width-4)/2
    var cellHeights:[CGFloat] = []
    var navigation:UINavigationController?
    
    lazy var tbvSchedule:UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = UIColor.clear
        tbv.separatorStyle = .none
        tbv.registerCellNib(TableCellSchedule.self)
        tbv.delegate = self
        tbv.dataSource = self
        return tbv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubView()
    }
}


extension TableSchedule:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listFilm.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as TableCellSchedule = cell else {
            return
        }
        
        cell.backgroundColor = UIColor.clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion:nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //cell.number = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellSchedule.identifier, for: indexPath) as! TableCellSchedule
        cell.film = listFilm[indexPath.row]
        cell.number = indexPath.row + 1
        cell.navigation = self.navigation
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row] + 3
    }
    
    // MARK: Table vie delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = listFilm[indexPath.row].heightContainer
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        
    }
}

extension TableSchedule{
    
    func showLoading(isShow: Bool) {
        let nav = (self.navigation as! NavigationController)
        nav.backgroundLoading.isHidden = !isShow
        if isShow {
            nav.loading.startAnimating()
        }else {
            nav.loading.stopAnimating()
        }
    }
    
    func addSubView() {
        self.tbvSchedule.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.tbvSchedule)
        self.tbvSchedule.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.tbvSchedule.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.backgroundAlpha
        refreshControl.attributedTitle = NSAttributedString(string: "Cập nhật dữ liệu", attributes: [NSForegroundColorAttributeName : UIColor.text, NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        refreshControl.tintColor = UIColor.text
        refreshControl.addTarget(self, action: #selector(TableViewEvent.refreshData), for: UIControlEvents.valueChanged)
        self.tbvSchedule.addSubview(refreshControl)
    }
    
    func loadData(){
        self.showLoading(isShow: true)
        ManagerData.share.getListFilmByDate(idCinema: idCinema!, date: date!, success: { (list, total) in
            self.listFilm = list
            self.showLoading(isShow: false)
            if self.listFilm.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected, action: { (isOtherButton) in
                    if isOtherButton {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }else{
                self.createCellHeightsArray()
                self.tbvSchedule.reloadData()
//                if self.padingBottom > 0{
//                    self.tbvSchedule.animateCells(animation: TableViewAnimation.Cell.left(duration: 0.5))
//                }
            }
        }) { (err) in
            self.showLoading(isShow: false)
            alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                if !isOtherButton {
                    self.loadData()
                }
            }
            print(err)
        }
    }
    
    func refreshData(sender: UIRefreshControl){
        sender.endRefreshing()
        self.listFilm = []
        self.tbvSchedule.reloadData()
        self.loadData()
    }
    
    func createCellHeightsArray() {
        for _ in 0...listFilm.count {
            cellHeights.append(kCloseCellHeight)
        }
    }
}
