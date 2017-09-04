//
//  SlideFilm.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/10/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import iCarousel

protocol SlideFilmDelegate{
    func loadSchedule()
}

class SlideFilm:UIView{
    
    var film:Film!
    var delegate:SlideFilmDelegate?
    
    let slide:iCarousel = {
        let slide = iCarousel()
        slide.type = .coverFlow
        return slide
    }()
    
    let lblName:MarqueeLabel = {
        let lbl = MarqueeLabel()
        lbl.font = UIFont(name: AppConstants.FontName.semibold, size: 17)
        lbl.textColor = UIColor.icon
        return lbl
    }()
    
    let segmentedClassification:UISegmentedControl = {
        let sgm = UISegmentedControl(items: ["Phân loại", "C18"])
        sgm.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], for: .normal)
        sgm.tintColor = UIColor.iconSelected
        sgm.selectedSegmentIndex = 0
        sgm.isUserInteractionEnabled = false
        return sgm
    }()
    let segmentedIMDB:UISegmentedControl = {
        let sgm = UISegmentedControl(items: ["Điểm IMDB", "C18"])
        sgm.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!], for: .normal)
        sgm.tintColor = UIColor.iconSelected
        sgm.selectedSegmentIndex = 0
        sgm.isUserInteractionEnabled = false
        return sgm
    }()
    let scrollView:UIScrollView = {
        let scv = UIScrollView()
        scv.backgroundColor = UIColor.background
        scv.layer.zPosition = 1
        return scv
    }()
    
    let btnHeart:DOFavoriteButton = {
        let btn = DOFavoriteButton(frame: CGRect.zero, image: #imageLiteral(resourceName: "heart"))
        btn.addTarget(self, action: #selector(SlideFilm.actionLike), for: UIControlEvents.touchUpInside)
        btn.layer.zPosition = 11
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let lblPremiere = UILabel()
    let lblLength = UILabel()
    let lblGenre = UILabel()
    let lblActor = UILabel()
    let lblDirector = UILabel()
    let lblCountry = UILabel()
    let lblIntro = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubView()
        //self.backgroundColor = UIColor.iconSelected()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SlideFilm{
    
    func addSubView(){
        lblPremiere.textColor = UIColor.text
        lblLength.textColor = UIColor.text
        lblGenre.textColor = UIColor.text
        lblActor.textColor = UIColor.text
        lblDirector.textColor = UIColor.text
        lblCountry.textColor = UIColor.text
        lblIntro.textColor = UIColor.text
        lblPremiere.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lblLength.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lblGenre.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lblActor.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lblDirector.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lblCountry.font = UIFont(name: AppConstants.FontName.regular, size: 16)
        lblIntro.font = UIFont(name: AppConstants.FontName.regular, size: 15)
        
        let btnSchedule:UIButton = {
            let btn = UIButton(type: .detailDisclosure)
            btn.tintColor = UIColor.iconSelected
            btn.setImage(#imageLiteral(resourceName: "calendar"), for: .normal)
            btn.addTarget(self, action: #selector(SlideFilm.actionSchedule), for: UIControlEvents.touchUpInside)
            return btn
        }()
        let viewBanner:UIVisualEffectView = {
            let v = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            v.addShadow()
            v.layer.zPosition = 2
            return v
        }()
        let lblContent:UILabel = {
            let lbl = UILabel()
            lbl.text = "Nội Dung"
            lbl.font = UIFont(name: AppConstants.FontName.semibold, size: 16)
            lbl.textColor = UIColor.background
            lbl.layer.borderWidth = 2
            lbl.layer.borderColor = UIColor.iconSelected.cgColor
            lbl.layer.cornerRadius = 15
            lbl.layer.backgroundColor = UIColor.iconSelected.cgColor
            lbl.textAlignment = .center
            return lbl
        }()
        self.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.slide)
        self.addViewWithContrains(VSFormat: "H:|[v0]|", views: viewBanner)
        self.addViewWithContrains(VSFormat: "H:|[v0]|", views: scrollView)
        self.addViewWithContrains(VSFormat: "V:|[v0(\((UIScreen.main.bounds.width/2)*(4/3)))][v1(40)][v2]|", views: self.slide, viewBanner, scrollView)
        viewBanner.addViewWithContrains(VSFormat: "H:|-16-[v0][v1(30)]", views: self.lblName, btnSchedule)
        viewBanner.addViewWithContrains(VSFormat: "H:[v0(45)]|", views: btnHeart)
        btnHeart.leftAnchor.constraint(equalTo: btnSchedule.rightAnchor, constant: -5).isActive = true
        lblName.centerYAnchor.constraint(equalTo: viewBanner.centerYAnchor).isActive = true
        btnHeart.centerYAnchor.constraint(equalTo: viewBanner.centerYAnchor).isActive = true
        btnSchedule.centerYAnchor.constraint(equalTo: viewBanner.centerYAnchor).isActive = true
        btnHeart.heightAnchor.constraint(equalToConstant: 45).isActive = true
        scrollView.addViewWithContrains(VSFormat: "H:|-8-[v0]-3-[v1]-8-|", views: self.segmentedClassification, self.segmentedIMDB)
        scrollView.addViewWithContrains(VSFormat: "V:|-15-[v0]", views: self.segmentedClassification)
        scrollView.addViewWithContrains(VSFormat: "V:|-15-[v0]-8-[v1][v2][v3][v4][v5][v6]-2-[v7]-4-[v8]-20-|", views: self.segmentedIMDB, self.lblPremiere, self.lblLength, self.lblGenre, self.lblCountry, self.lblDirector, self.lblActor, lblContent, self.lblIntro)
        let w = UIScreen.main.bounds.width - 20
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblPremiere)
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblLength)
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblGenre)
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblActor)
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblDirector)
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblCountry)
        scrollView.addViewWithContrains(VSFormat: "H:|-10-[v0(\(w))]|", views: self.lblIntro)
        lblContent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        lblContent.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lblContent.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.lblIntro.numberOfLines = 0
        self.lblActor.numberOfLines = 0
    }
    
    func actionLike(sender:DOFavoriteButton){
        if let user = ManagerUser.user{
            sender.isEnabled = false
            if !user.isLikeFilm(id: film.id!) {
                sender.select()
                ManagerData.share.like(email: user.email!, id: film.id!, categorie: "film", success: {
                    sender.isEnabled = true
                    user.listFilm?.append(self.film)
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            } else {
                sender.deselect()
                ManagerData.share.unlike(email: user.email!, id: film.id!, categorie: "film", success: {
                    sender.isEnabled = true
                    user.listFilm = user.listFilm?.filter{$0.id != self.film.id}
                }, fail: { (err) in
                    sender.isEnabled = true
                    print(err)
                })
            }
        }
    }
    
    func actionSchedule(){
        self.delegate?.loadSchedule()
    }
    
}

class SlideItem:UIImageView{
    
    var film:Film!{
        didSet{
            isHot.isHidden = !film.isHot!
            loadImage(strURL: film.linkPoster) { (err) in
                print(err)
            }
        }
    }
    
    let isHot:UIView = {
        let imv = UIView()
        let lbl = UILabel()
        let v = UIView()
        
        lbl.text = "HOT"
        lbl.font = UIFont(name: AppConstants.FontName.bold, size: 16)
        lbl.addShadow()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.textAlignment = .center
        lbl.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        lbl.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        lbl.roundCorners(corners: [.topRight], radius: 8)
        imv.addSubview(lbl)
        imv.contentMode = .scaleAspectFill
        imv.isHidden = true
        return imv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.isHot.frame = CGRect(x: 0, y: self.bounds.height - 30, width: 50, height: 30)
        self.addSubview(self.isHot)
        self.addShadow()
        let imvTrailer = UIImageView(image: #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate))
        imvTrailer.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addViewWithContrains(VSFormat: "H:[v0(50)]", views: imvTrailer)
        imvTrailer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imvTrailer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imvTrailer.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
