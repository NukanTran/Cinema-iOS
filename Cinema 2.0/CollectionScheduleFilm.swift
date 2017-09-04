//
//  TableSchedule.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/15/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import UICollectionViewLeftAlignedLayout

class CollectionScheduleFilm:BaseViewController{
    
    var listSchedule:[Schedule] = []
    var collectionView:UICollectionView?
    var navigation:UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addNotifyButton()
        self.addSubView()
    }
    
    override func addSubView() {
        super.addSubView()
        self.navigationItem.titleView?.tintColor = UIColor.iconSelected
        let layout = UICollectionViewLeftAlignedLayout()
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.collectionView!)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]|", views: self.collectionView!)
        self.collectionView?.backgroundColor = UIColor.icon
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.registerCells(CollectionCellSchedule.self)
    }
}

extension CollectionScheduleFilm:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listSchedule.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellSchedule.identifier, for: indexPath) as! CollectionCellSchedule
        cell.schedule = listSchedule[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.listSchedule[indexPath.row].disable{
            if let url = URL(string: self.listSchedule[indexPath.row].linkTicket!){
                alert.showAlert("Thông Báo", subTitle: "Bạn phải đăng nhập tài khoản của rạp phim này để đặt vé online!", style: .warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Đồng Ý", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                    if !isOtherButton {
                        let ticket = WebViewTicket()
                        ticket.url = url
                        ticket.title = "Đặt Vé Online"
                        tabBar.present(ticket, animated: true, completion: nil)
//                        self.navigation?.pushViewController(ticket, animated: true)
                    }
                }
            }else{
                _ = alert.showAlert("Thông Báo", subTitle: "Rạp chưa hỗ trợ đặt vé online!", style: .warning, buttonTitle: "Đồng Ý")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
