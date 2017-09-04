//
//  ExtentionFont.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/10/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

extension UIFont {
    static let bold             = UIFont(name: AppConstants.FontName.bold, size: 16)
    static let boldItalic       = UIFont(name: AppConstants.FontName.boldItalic, size: 16)
    static let extraBold        = UIFont(name: AppConstants.FontName.extraBold, size: 16)
    static let extraBoldItalic  = UIFont(name: AppConstants.FontName.extraBoldItalic, size: 16)
    static let italic           = UIFont(name: AppConstants.FontName.italic, size: 16)
    static let light            = UIFont(name: AppConstants.FontName.light, size: 16)
    static let lightItalic      = UIFont(name: AppConstants.FontName.lightItalic, size: 16)
    static let regular          = UIFont(name: AppConstants.FontName.regular, size: 16)
    static let semibold         = UIFont(name: AppConstants.FontName.semibold, size: 16)
    static let semiboldItalic   = UIFont(name: AppConstants.FontName.semiboldItalic, size: 16)
    static let funkydori        = UIFont(name: AppConstants.FontName.funkydori, size: 16)
    
    func size(_ size:CGFloat)->UIFont{
        return self.withSize(size)
    }
}
