//
//  TableViewEvent.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/8/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class TableViewEvent:UITableViewController{
    
    var parentNavigationController : UINavigationController?
    var idProducer:String?
    var listEvent:[Event] = []
    var totalPage:Int = 0
    var page:Int = 1
    var loading = false
    var isSelect = false
    
    init(style: UITableViewStyle, idProducer:String) {
        super.init(style: style)
        self.idProducer = idProducer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubView()
        self.showLoading(isShow: true)
    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if isSelect{
//            self.isSelect = false
//            self.loadData()
//        }
//    }
    
    
}

extension TableViewEvent{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEvent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellEvent.identifier, for: indexPath) as! TableCellEvent
        cell.event = self.listEvent[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width/2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailEventController()
        detail.event = listEvent[indexPath.row]
        self.parentNavigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= listEvent.count-5 && page <= totalPage{
            self.loadData()
        }
    }
    
}

extension TableViewEvent{
    
    func addSubView(){
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.registerCells(TableCellEvent.self)
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.backgroundAlpha
        refreshControl.attributedTitle = NSAttributedString(string: "Cập nhật dữ liệu", attributes: [NSForegroundColorAttributeName : UIColor.text, NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        refreshControl.tintColor = UIColor.text
        refreshControl.addTarget(self, action: #selector(TableViewEvent.refreshData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refreshData(sender: UIRefreshControl){
        sender.endRefreshing()
        self.listEvent = []
        self.page = 1
        self.tableView.reloadData()
        self.showLoading(isShow: true)
        self.loadData()
    }
    
    func loadData(){
        if !loading{
            if listEvent.count <= 0{
                self.showLoading(isShow: true)
            }
            self.loading = true
            ManagerData.share.getListEvent(page: page, idProducer: self.idProducer!, success: { (listEvent, totalPage) in
                self.totalPage = totalPage
                self.page += 1
                self.listEvent += listEvent
                self.tableView.reloadData()
//                if self.padingBottom > 0 && listEvent.count == self.listEvent.count{
//                    self.tableView.animateCells(animation: TableViewAnimation.Cell.left(duration: 0.5))
//                }
                if self.listEvent.count < 1 {
                    _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
                }
                self.loading = false
                self.showLoading(isShow: false)
            }) { (error) in
                self.loading = false
                self.showLoading(isShow: false)
                alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                    if !isOtherButton {
                        self.showLoading(isShow: true)
                        self.loadData()
                    }
                }
            }
        }
    }
    
    func showLoading(isShow: Bool) {
        let nav = self.parentNavigationController as! NavigationController
        nav.backgroundLoading.isHidden = !isShow
        if isShow {
            nav.loading.startAnimating()
        }else {
            nav.loading.stopAnimating()
        }
    }
    
}
