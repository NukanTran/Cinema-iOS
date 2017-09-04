//
//  ViewMenu.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/28/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ViewMenu:UIView{
    
    var closeAction: ((Int)->Void)?
    
    lazy var tableView:UITableView = {
        let tbv = UITableView(frame: .zero)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorStyle = .none
        tbv.rowHeight = 50
        tbv.isScrollEnabled = false
        tbv.registerCells(TreeCellProducer.self)
        return tbv
    }()
    
   fileprivate var menu = ["Đổi mật khẩu", "Cập nhật thông tin", "Đăng xuất tài khoản"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViewWithContrains(VSFormat: "H:|[v0]-3-|", views: tableView)
        self.addViewWithContrains(VSFormat: "V:|-8-[v0]-8-|", views: tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewMenu:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TreeCellProducer.identifier) as! TreeCellProducer
        cell.lblText.text = menu[indexPath.row]
        cell.menuArrow.isHidden = true
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.lblText.font = UIFont.regular?.size(16)
        switch indexPath.row {
        case 0:
            cell.imvIcon.image = #imageLiteral(resourceName: "user_pass")
            break
        case 1:
            cell.imvIcon.image = #imageLiteral(resourceName: "user_edit")
            break
        case 2:
            cell.imvIcon.image = #imageLiteral(resourceName: "user_logout")
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let close = closeAction{
            close(indexPath.row)
        }
    }
}
