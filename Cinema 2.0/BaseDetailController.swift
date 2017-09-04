//
//  BaseDetailController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/9/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import MIBlurPopup

class BaseDetailController:BaseViewController{
    
    var listImage:[String] = []
    var textBanner:String = ""
    var viewContent = UIView()
    let heightImage = UIScreen.main.bounds.width*2/3 - 40
    var heightContent:CGFloat = 0{
        didSet{
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }
    
    let imvBanner:UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    lazy var tableView:UITableView = {
        let tbv = UITableView(frame: .zero)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorStyle = .none
        tbv.allowsSelection = false
        tbv.backgroundColor = UIColor.background
        tbv.registerCells(UITableViewCell.self)
        return tbv
    }()
    
    let btnHeart:DOFavoriteButton = {
        let btn = DOFavoriteButton(frame: CGRect.zero, image: #imageLiteral(resourceName: "heart"))
        btn.addTarget(self, action: #selector(BaseDetailController.actionLike), for: UIControlEvents.touchUpInside)
        btn.layer.zPosition = 11
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
    }
    
}

extension BaseDetailController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.addViewWithContrains(VSFormat: "H:|[v0]|", views: viewContent)
        cell.addViewWithContrains(VSFormat: "V:|[v0]|", views: viewContent)
        viewContent.backgroundColor = UIColor.background
        viewContent.heightAnchor.constraint(equalToConstant: 500).isActive = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return heightImage
        }
        return heightContent
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vse = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        vse.backgroundColor = UIColor.background
        let imv = UIImageView(image: #imageLiteral(resourceName: "tag").withRenderingMode(.alwaysTemplate))
        imv.tintColor = UIColor.iconSelected
        let lblBanner = MarqueeLabel()
        lblBanner.type = .continuous
        lblBanner.text = textBanner
        lblBanner.font = UIFont.semibold?.size(17)
        vse.addViewWithContrains(VSFormat: "H:|-10-[v0(20)]-8-[v1]-4-[v2(45)]|", views: imv, lblBanner, btnHeart)
        vse.addViewWithContrains(VSFormat: "V:|-10-[v0]-10-|", views: imv)
        vse.addViewWithContrains(VSFormat: "V:|-10-[v0]-10-|", views: lblBanner)
        btnHeart.centerYAnchor.constraint(equalTo: vse.centerYAnchor).isActive = true
        btnHeart.heightAnchor.constraint(equalToConstant: 45).isActive = true
        vse.addShadow()
        return vse
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentOffset.y <= heightImage{
            imvBanner.frame.size.height = heightImage - scrollView.contentOffset.y
        }else{
            imvBanner.frame.size.height = 0
        }
    }
}

extension BaseDetailController{
    
    override func addSubView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: tableView)
        tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        imvBanner.heightAnchor.constraint(equalToConstant: heightImage).isActive = true
        imvBanner.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: heightImage)
        self.view.addSubview(imvBanner)
        let btn = UIButton()
        btn.backgroundColor = .clear
        imvBanner.addViewWithContrains(VSFormat: "H:|[v0]|", views: btn)
        imvBanner.addViewWithContrains(VSFormat: "V:|[v0]|", views: btn)
        btn.addTarget(self, action: #selector(BaseDetailController.actionViewImage), for: .touchUpInside)
        imvBanner.isUserInteractionEnabled = true
        imvBanner.loadImage(strURL: listImage[0]) { (err) in
            print(err)
        }
    }
    
    func setTitle(title:String){
        let lblTitle:MarqueeLabel = {
            let lbl = MarqueeLabel()
            lbl.type = .leftRight
            lbl.textColor = UIColor.icon
            lbl.font = UIFont.semibold?.size(17)
            lbl.textAlignment = .center
            return lbl
        }()
        lblTitle.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        lblTitle.text = title
        navigationItem.titleView = lblTitle
    }
        
    func actionViewImage(){
        let clvViewImage = CollectionViewImage(collectionViewLayout: UICollectionViewFlowLayout())
        clvViewImage.listImage = self.listImage
        MIBlurPopup.show(clvViewImage, on: self.tabBarController!)
    }
    
    func actionLike(sender:DOFavoriteButton){
        
    }
}
