//
//  TreeCellCinema.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class TreeCellCinema:BaseTableCell{
    
    private let lblText:MarqueeLabel = {
        let lbl = MarqueeLabel()
        lbl.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lbl.type = .leftRight
        lbl.textColor = UIColor.text
        return lbl
    }()
    private let imvIcon = UIImageView()
    private let lblAddress:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: AppConstants.FontName.regular, size: 11)
        lbl.textColor = UIColor.textAlpha
        lbl.numberOfLines = 2
        //lbl.type = .continuous
        return lbl
    }()
    private let lblKM:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: AppConstants.FontName.italic, size: 13)
        lbl.textColor = #colorLiteral(red: 0.1839532554, green: 0.5116228461, blue: 0.7886465788, alpha: 1)
        lbl.text = "..."
        return lbl
    }()
    
    var cinema:Cinema!{
        didSet{
            lblText.text = cinema.name
            lblAddress.text = cinema.address
            if let mapData = cinema.mapData{
                lblKM.text = mapData.routes?[0].legs?[0].distance?.text
            }else{
                lblKM.text = "..."
            }
            if cinema.minDistance{
                lblKM.textColor = UIColor.red
            }else{
                lblKM.textColor = #colorLiteral(red: 0.1839532554, green: 0.5116228461, blue: 0.7886465788, alpha: 1)
            }
        }
    }
    
    override func addSubView() {
        let imvMap = UIImageView(image: #imageLiteral(resourceName: "route"))
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imvIcon.tintColor = UIColor.iconSelected
        imvIcon.image = #imageLiteral(resourceName: "address").withRenderingMode(.alwaysTemplate)
        addViewWithContrains(VSFormat: "H:|-25-[v0(25)]-8-[v1]-4-[v2(20)]-4-[v3(60)]|", views: imvIcon, lblText, imvMap, lblKM)
        addViewWithContrains(VSFormat: "V:|-4-[v0][v1]-2-|", views: lblText, lblAddress)
        addViewWithContrains(VSFormat: "V:|-15-[v0(25)]|", views: imvIcon)
        addViewWithContrains(VSFormat: "V:|-4-[v0(20)]", views: imvMap)
        addViewWithContrains(VSFormat: "V:|-10-[v0]", views: lblKM)
        lblAddress.leftAnchor.constraint(equalTo: imvIcon.rightAnchor, constant: 8).isActive = true
        lblAddress.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    }
}
