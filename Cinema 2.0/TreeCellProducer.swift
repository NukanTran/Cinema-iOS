//
//  TreeCellProducer.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class TreeCellProducer:BaseTableCell{
    
    let lblText = UILabel()
    let imvIcon = UIImageView()
    var menuArrow = UIImageView(image: #imageLiteral(resourceName: "down-arrow").withRenderingMode(.alwaysTemplate))
    var close = true{
        didSet{
            menuArrow.image = close ? #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "down-arrow").withRenderingMode(.alwaysTemplate)
        }
    }
    
    override func addSubView() {
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
    }
}
