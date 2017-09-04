//
//  GuiController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/10/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class GuiController:UIViewController{
    
    let btnNext:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .iconSelected
        btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 18)
        btn.setTitle("Xong", for: .normal)
        UIApplication.shared.isStatusBarHidden = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addSubview()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GuiController{
    
    func addSubview(){
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.btnNext)
        self.view.addViewWithContrains(VSFormat: "V:[v0(50)]|", views: self.btnNext)
    }
}
