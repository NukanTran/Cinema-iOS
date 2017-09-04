//
//  ViewImageCollection.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/9/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import MIBlurPopup

class CollectionViewImage:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var listImage:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.clear
        let btnClose = UIButton()
        self.collectionView?.registerCells(CollectionCellViewImage.self)
        self.collectionView?.isPagingEnabled = true
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        self.view.addViewWithContrains(VSFormat: "H:|-10-[v0(30)]", views: btnClose)
        self.view.addViewWithContrains(VSFormat: "V:|-30-[v0(30)]", views: btnClose)
        btnClose.setImage(#imageLiteral(resourceName: "close").withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        btnClose.addTarget(self, action: #selector(CollectionViewImage.closeView), for: .touchUpInside)
        btnClose.tintColor = UIColor.iconSelected
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellViewImage.identifier, for: indexPath) as! CollectionCellViewImage
        cell.imageView.loadImage(strURL: listImage[indexPath.row]) { (err) in
            print(err)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CollectionViewImage:MIBlurPopupDelegate{
    
    var popupView: UIView {
        return self.view
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount: CGFloat {
        return 0.3
    }
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}

class CollectionCellViewImage:BaseCollectionCell{
    
    let imageView:UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFit
        imv.clipsToBounds = true
        return imv
    }()
    
    override func addSubView() {
        self.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.imageView)
        self.addViewWithContrains(VSFormat: "V:|[v0]|", views: self.imageView)
    }
}
