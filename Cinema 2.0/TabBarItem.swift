//
//  TabBarItem.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/6/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarItem: ESTabBarItemContentView {
    public let duration = 0.3
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.iconColor = UIColor.icon
        self.highlightIconColor = UIColor.iconSelected
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        //self.titleLabel.isHidden = false
        completion?()
    }
    override func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        super.badgeChangedAnimation(animated: animated, completion: nil)
        notificationAnimation()
    }
    func bounceAnimation() {
//        self.titleLabel.isHidden = true
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = kCAAnimationCubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    func notificationAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        impliesAnimation.values = [0.0 ,-8.0, 4.0, -4.0, 3.0, -2.0, 0.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = kCAAnimationCubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}

class TabBarItemForUser: ESTabBarItemContentView {
    
    let viewUsser:UIView = {
        let v  = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.frame = CGRect(x: 1, y: -10, width: 58, height: 100)
        return v
    }()
    
    init(frame: CGRect, avatar:UIImageView) {
        super.init(frame: frame)
        self.titleLabel.isHidden = true
        let v = UIView()
        let vseUser:UIView = {
            let v = UIView()
            v.alpha = 0.5
            v.backgroundColor = #colorLiteral(red: 0.6018019319, green: 0.6693834066, blue: 0.7476165891, alpha: 1)
            v.frame = CGRect(x: 0, y: -11, width: 60, height: 60)
            v.addShadow()
            return v
        }()
        v.backgroundColor = .clear
        self.addViewWithContrains(VSFormat: "V:|[v0]|", views: v)
        v.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        v.widthAnchor.constraint(equalToConstant: 60).isActive = true
        vseUser.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        viewUsser.roundCorners(corners: [.topLeft, .topRight], radius: 29)
        viewUsser.addViewWithContrains(VSFormat: "H:|-3-[v0]-3-|", views: avatar)
        viewUsser.addViewWithContrains(VSFormat: "V:|-3-[v0]", views: avatar)
        avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor).isActive = true
        v.addSubview(vseUser)
        v.addSubview(viewUsser)
        backdropColor = .clear
        highlightBackdropColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.viewUsser.backgroundColor = UIColor.iconSelected
    }
    public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.viewUsser.backgroundColor = UIColor(hex: "#607D8B")
        completion?()
    }
    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = self.viewUsser.transform.scaledBy(x: 0.8, y: 0.8)
        self.viewUsser.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        self.viewUsser.transform = transform
        UIView.commitAnimations()
        completion?()
    }
}
