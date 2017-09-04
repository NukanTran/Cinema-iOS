//
//  DetailEvent.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/9/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

class DetailEventController:BaseDetailController{
    
    var event:Event!{
        didSet{
            self.setBackgroundImage(strURL: event.linkPoster!)
            self.listImage = [event.linkPoster!]
            if let name = event.name{
                self.setTitle(title: name)
            }
            if let time = event.time{
                self.textBanner = time
            }
            let lblIntro:UILabel = {
                let lbl = UILabel()
                lbl.textColor = UIColor.text
                lbl.font = UIFont(name: AppConstants.FontName.regular, size: 15)
                lbl.numberOfLines = 0
                if let intro = event.intro{
                    lbl.text = intro
                }
                return lbl
            }()
            self.viewContent.addViewWithContrains(VSFormat: "H:|-8-[v0]-8-|", views: lblIntro)
            self.viewContent.addViewWithContrains(VSFormat: "V:|-8-[v0]-8-|", views: lblIntro)
            self.heightContent = (event.intro?.height(withConstrainedWidth: UIScreen.main.bounds.width - 16, font: lblIntro.font))! + 20            
            let shareItem = ShareItem()
            shareItem.title = self.event.name
            shareItem.content = self.event.intro
            shareItem.stringURL = "\(AppConstants.HOST)detailevent.aspx?id=\(self.event.id!)"
            UIImageView().loadImage(strURL: self.event.linkPoster, success: { (image) in
                shareItem.image = image
                self.addShareButton(shareItem: shareItem)
            }) { (err) in
                print(err)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = ManagerUser.user, user.isLikeEvent(id: event.id!){
            self.btnHeart.select()
        }
    }
    
    override func actionLike(sender: DOFavoriteButton) {
        if let user = ManagerUser.user{
            sender.isEnabled = false
            if !user.isLikeEvent(id: event.id!){
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

