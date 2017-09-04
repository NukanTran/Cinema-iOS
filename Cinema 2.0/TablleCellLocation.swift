//
//  TablleCellLocation.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/10/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class TablleCellLocation:BaseTableCell{
    
    let lblText = UILabel()
    let imvIcon = UIImageView()
    
    override func addSubView() {
        lblText.textColor = UIColor.text
        lblText.font = UIFont.regular?.size(16)
        imvIcon.image = #imageLiteral(resourceName: "tag").withRenderingMode(.alwaysTemplate)
        imvIcon.tintColor = .iconSelected
        imvIcon.isHidden = true
        addViewWithContrains(VSFormat: "H:|-5-[v0(15)]-3-[v1]|", views: imvIcon, lblText)
        addViewWithContrains(VSFormat: "V:|[v0]|", views: lblText)
        addViewWithContrains(VSFormat: "V:|-13-[v0]-12-|", views: imvIcon)
    }
}
