//
//  CinemaInfo.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/23/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class CinemaInfo:UIViewController{
    
    let scrollView:UIScrollView = {
        let scv = UIScrollView()
        scv.backgroundColor = UIColor.background
        scv.layer.zPosition = 1
        return scv
    }()
    
    let lblPhoneNumber:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.text
        lbl.font = UIFont.regular?.size(16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lblAddress:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.text
        lbl.font = UIFont.regular?.size(16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lblIntro:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.text
        lbl.font = UIFont.regular?.size(15)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubView()
    }
}

extension CinemaInfo{
    func addSubView(){
        let lblContent:UILabel = {
            let lbl = UILabel()
            lbl.text = "Giới thiệu"
            lbl.font = UIFont.semibold?.size(16)
            lbl.textColor = UIColor.background
            lbl.layer.borderWidth = 2
            lbl.layer.borderColor = UIColor.iconSelected.cgColor
            lbl.layer.cornerRadius = 15
            lbl.layer.backgroundColor = UIColor.iconSelected.cgColor
            lbl.textAlignment = .center
            return lbl
        }()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 113 - 74)
        self.view.addSubview(self.scrollView)
        scrollView.addViewWithContrains(VSFormat: "H:|-8-[v0]-8-|", views: lblPhoneNumber)
        scrollView.addViewWithContrains(VSFormat: "H:|-8-[v0]-8-|", views: lblAddress)
        scrollView.addViewWithContrains(VSFormat: "H:|-\(UIScreen.main.bounds.width/2 - 50)-[v0(100)]", views: lblContent)
        lblContent.heightAnchor.constraint(equalToConstant: 30).isActive = true
        scrollView.addViewWithContrains(VSFormat: "H:|-8-[v0]-8-|", views: lblIntro)
        scrollView.addViewWithContrains(VSFormat: "V:|-8-[v0][v1]-2-[v2]-4-[v3]-8-|", views: lblPhoneNumber, lblAddress, lblContent, lblIntro)
        lblIntro.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 16).isActive = true
    }
}

