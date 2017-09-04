//
//  TableCellSchedule.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/22/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import FoldingCell
import MIBlurPopup

class TableCellSchedule:FoldingCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberForeground: UILabel!
    @IBOutlet weak var hotForeground: UIImageView!
    @IBOutlet weak var lblHot: UILabel!
    @IBOutlet weak var nameForeground: MarqueeLabel!
    @IBOutlet weak var imvBannerForeground: UIImageView!
    @IBOutlet weak var numberContainer: UILabel!
    @IBOutlet weak var nameContainer: MarqueeLabel!
    @IBOutlet weak var imvBannerContainer: UIImageView!
    @IBOutlet weak var heightContainer: NSLayoutConstraint!
    
    @IBAction func trailerForeground(_ sender: Any) {
        loadTrailer()
    }
    
    @IBAction func trailerContainer(_ sender: Any) {
        loadTrailer()
    }
    
    var listSchedule:[Schedule] = []
    var navigation:UINavigationController?
    
    var film:Film!{
        didSet{
            let name = NSMutableAttributedString(string: film.name! + " - ", attributes: nil)
            name.append(NSAttributedString(string: film.slot + "  ", attributes: [ NSForegroundColorAttributeName: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) ]))
            listSchedule = film.listSchedule!
            nameForeground.attributedText = name
            hotForeground.isHidden = !film.isHot!
            lblHot.isHidden = !film.isHot!
            nameContainer.attributedText = name
            heightContainer.constant = film.heightContainer
            imvBannerForeground.loadImage(strURL: film.linkBanner) { (err) in
                print(err)
            }
            imvBannerContainer.loadImage(strURL: film.linkBanner) { (err) in
                print(err)
            }
            collectionView.reloadData()
        }
    }
    
    var number:Int!{
        didSet{
            numberForeground.text = "\(number!)"
            numberContainer.text = "\(number!)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 3
        foregroundView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        foregroundView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 3
        containerView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.masksToBounds = true
        hotForeground.layer.cornerRadius = 8
        self.collectionView?.registerCells(CollectionCellSchedule.self)
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        let durations = [0.26, 0.2, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func loadTrailer() {
        if let url = URL(string: film.linkTrailer!){
            let trailer = WebViewTrailer()
            trailer.url = url
            MIBlurPopup.show(trailer, on: tabBar)
        }else{
            _ = alert.showAlert("Thông Báo", subTitle: "Trailer phim chưa được cập nhật!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
        }
    }
}

extension TableCellSchedule:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
                        self.navigation?.present(ticket, animated: true, completion: nil)
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
