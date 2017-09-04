//
//  ExtensionsUIKit.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/8/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import RATreeView
import PINRemoteImage

extension UIView{
    func addViewWithContrains(VSFormat:String, views:UIView...){
        var dic = Dictionary<String, UIView>()
        for(i, v) in views.enumerated(){
            let key:String = "v\(i)"
            v.translatesAutoresizingMaskIntoConstraints = false
            dic[key] = v
            if !(v.isDescendant(of: self)){
                self.addSubview(v)
            }
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: VSFormat, options: NSLayoutFormatOptions(), metrics: nil, views: dic))
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = mask
    }
    
    func addShadow(){
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    
    func addShadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat, shadowPath: CGPath? = nil) {
        layer.masksToBounds = false
        layer.shadowPath = shadowPath
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImageView{
    
    func loadImage(strURL:String?, success: @escaping (_ image:UIImage) -> (), fail: @escaping (_ error: String) -> ()) {
        if let strURL = strURL, let url = URL(string: strURL){
            self.pin_updateWithProgress = true
            self.pin_setImage(from: url, placeholderImage: UIImage(color: UIColor.icon), completion: { (res) in
                if res.error == nil{
                    success(res.image!)
                }else{
                    self.contentMode = .center
                    self.image = #imageLiteral(resourceName: "error")
                    fail((res.error?.localizedDescription)!)
                }
            })
        }else{
            self.contentMode = .center
            self.image = #imageLiteral(resourceName: "error")
            fail("Địa chỉ hình ảnh không hợp lệ!")
        }
    }
    
    func loadImage(strURL:String?, fail: @escaping (_ error: String) -> ()) {
        if let strURL = strURL, let url = URL(string: strURL){
            self.pin_updateWithProgress = true
            self.pin_setImage(from: url, placeholderImage: UIImage(color: UIColor.icon), completion: { (res) in
                if res.error != nil{
                    self.contentMode = .center
                    self.image = #imageLiteral(resourceName: "error")
                    fail((res.error?.localizedDescription)!)
                }
            })
        }else{
            self.contentMode = .center
            self.image = #imageLiteral(resourceName: "error")
            fail("Địa chỉ hình ảnh không hợp lệ!")
        }
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}

//extension UICollectionViewCell {
//    
//    static var identifier: String {
//        return String(describing: self)
//    }
//}

extension UICollectionReusableView {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView{
    
    func registerCells(_ cells:AnyClass...){
        for (_, cell) in cells.enumerated(){
            self.register(cell, forCellReuseIdentifier: String(describing: cell))
        }
    }
    
    func registerHeaderFooters(_ cells:AnyClass...){
        for (_, cell) in cells.enumerated(){
            self.register(cell, forHeaderFooterViewReuseIdentifier: String(describing: cell))
        }
    }
    
    func registerCellNib(_ cells:AnyClass...){
        for (_, cell) in cells.enumerated(){
            self.register(UINib(nibName: String(describing: cell), bundle: nil) , forCellReuseIdentifier: String(describing: cell))
        }
    }
}

extension UICollectionView{
    
    func registerCells(_ cells:AnyClass...){
        for (_, cell) in cells.enumerated(){
            self.register(cell, forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}

extension RATreeView{
    
    func registerCells(_ cells:AnyClass...){
        for (_, cell) in cells.enumerated(){
            self.register(cell, forCellReuseIdentifier: String(describing: cell))
        }
    }
}
