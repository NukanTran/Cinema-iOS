//
//  TableHearderUser.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/10/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class TableHeaderUser:UITableViewHeaderFooterView{
    
    let lblText = UILabel()
    let imvIcon = UIImageView()
    var menuArrow = UIImageView(image: #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate))
    var actionSetting:(()->Void)!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubView() {
        menuArrow.contentMode = .scaleAspectFit
        menuArrow.tintColor = UIColor.iconSelected
        backgroundColor = UIColor.background
        lblText.textColor = UIColor.text
        lblText.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
        imvIcon.image = #imageLiteral(resourceName: "star")
        imvIcon.tintColor = UIColor.iconSelected
        addViewWithContrains(VSFormat: "H:|-15-[v0(30)]-8-[v1]-8-[v2(10)]-15-|", views: imvIcon, lblText, menuArrow)
        addViewWithContrains(VSFormat: "V:|[v0]|", views: lblText)
        addViewWithContrains(VSFormat: "V:|-10-[v0]-10-|", views: imvIcon)
        addViewWithContrains(VSFormat: "V:|-15-[v0]-15-|", views: menuArrow)
        let btn = UIButton()
        btn.addTarget(self, action: #selector(TableHeaderUser.didSelected), for: .touchUpInside)
        addViewWithContrains(VSFormat: "H:|[v0]|", views: btn)
        addViewWithContrains(VSFormat: "V:|[v0]|", views: btn)
    }
    
    func didSelected(){
        if let action = actionSetting{ action() }
    }
}
