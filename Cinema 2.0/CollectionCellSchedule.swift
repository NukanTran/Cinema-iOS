//
//  CollectionCellSchedule.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/20/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class CollectionCellSchedule:BaseCollectionCell{
    
    private let lblTime = UILabel()
    private let lblSlot = UILabel()
    
    var schedule:Schedule!{
        didSet{
            lblTime.text = schedule.time
            lblSlot.text = schedule.slot?.uppercased()
            lblSlot.backgroundColor = (schedule.slot?.uppercased().contains("2D"))! ? #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) : #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            self.backgroundColor = schedule.disable ? UIColor.textAlpha : UIColor.iconSelected
            
        }
    }
    
    override func addSubView() {
        self.lblTime.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblTime.font = UIFont(name: AppConstants.FontName.regular, size: 22)
        self.lblSlot.font = UIFont(name: AppConstants.FontName.semiboldItalic, size: 13)
        self.lblSlot.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSlot.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.lblSlot.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.lblSlot.layer.shadowOpacity = 0.3
        self.lblSlot.layer.shadowRadius = 2
        self.lblSlot.textAlignment = .center
        self.lblSlot.numberOfLines = 0
        self.addViewWithContrains(VSFormat: "H:|[v0][v1]|", views: self.lblTime, self.lblSlot)
        self.lblSlot.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        self.lblTime.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.lblSlot.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //self.lblSlot.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.backgroundColor = UIColor.iconSelected
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
}
