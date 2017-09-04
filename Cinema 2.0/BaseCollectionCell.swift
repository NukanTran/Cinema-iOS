//
//  BaseCollectionCell.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class BaseCollectionCell:UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubView(){
        
    }
    
}
