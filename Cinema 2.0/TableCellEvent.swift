//
//  TableCellEvent.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class TableCellEvent: BaseTableCell{
    
    var event:Event!{
        didSet{
            self.lblTitle.text = self.event.name
            self.lblTime.text = self.event.time
            if let btn = self.viewWithTag(526) as? DOFavoriteButton{
                //                btn.isSelected = false
                if let user = ManagerUser.user{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        btn.select()
                        btn.isSelected = user.isLikeEvent(id: self.event.id!)
                    }
                }
            }
            self.imvBanner.loadImage(strURL: self.event.linkPoster) { (err) in
                print(err)
            }
        }
    }
    
    private let lblTitle:MarqueeLabel = {
        let lbl = MarqueeLabel()
        lbl.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.type = .continuous
        return lbl
    }()
    
    private let lblTime:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: AppConstants.FontName.semiboldItalic, size: 13)
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let imvBanner:UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        imv.layer.masksToBounds = true
        imv.layer.cornerRadius = 3
        let vse = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        imv.addViewWithContrains(VSFormat: "H:|[v0]|", views: vse)
        imv.addViewWithContrains(VSFormat: "V:[v0(48)]|", views: vse)
        imv.layer.borderWidth = 1
        imv.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        return imv
    }()
    
    override func addSubView(){
        
        let btnHeart:DOFavoriteButton = {
            let btn = DOFavoriteButton(frame: CGRect.zero, image: #imageLiteral(resourceName: "heart"))
            btn.addTarget(self, action: #selector(SlideFilm.actionLike), for: UIControlEvents.touchUpInside)
            btn.layer.zPosition = 11
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.tag = 526
            return btn
        }()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
            btnHeart.select()
            btnHeart.isSelected = false
        }
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.addViewWithContrains(VSFormat: "H:|-2-[v0]-2-|", views: self.imvBanner)
        self.addViewWithContrains(VSFormat: "V:|-2-[v0]|", views: self.imvBanner)
        self.addViewWithContrains(VSFormat: "H:|-8-[v0][v1(45)]|", views: self.lblTitle, btnHeart)
        self.addViewWithContrains(VSFormat: "H:|-8-[v0]-8-|", views: self.lblTime)
        self.lblTime.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.lblTime.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor).isActive = true
        btnHeart.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        btnHeart.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func actionLike(sender:DOFavoriteButton){
        if let user = ManagerUser.user{
            sender.isEnabled = false
            if !user.isLikeEvent(id: event.id!) {
                sender.select()
                ManagerData.share.like(email: user.email!, id: event.id!, categorie: "event", success: {
                    sender.isEnabled = true
                    user.listEvent?.append(self.event)
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            } else {
                sender.deselect()
                ManagerData.share.unlike(email: user.email!, id: event.id!, categorie: "event", success: {
                    sender.isEnabled = true
                    user.listEvent = user.listEvent?.filter{$0.id != self.event.id}
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            }
        }
        
    }
    
}
