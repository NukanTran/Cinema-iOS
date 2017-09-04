//
//  APIKey.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/22/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import SwiftyUserDefaults
import UIKit

enum AppConstants{
    
    static let HOST = "http://www.lichchieuvn.com/"
    
    static let cryptoKey128 = "0210021002100210"
    static var userName = Defaults[.userName]
    static var passwword = Defaults[.password]
    
    enum APIKey {
        static let gMapAPIKey           = "AIzaSyD6V5SbXi_Kp_ldQSWNePZEwEK-DblK5UM"
        static let gDirectionsAPIKey    = "AIzaSyApWXLrLgUE_ZoAc6hv0wgKzu6Z-lhWZ8c"
    }
    
    enum FontName {
        static let bold             = "OpenSans-Bold"
        static let boldItalic       = "OpenSans-BoldItalic"
        static let extraBold        = "OpenSans-ExtraBold"
        static let extraBoldItalic  = "OpenSans-ExtraBoldItalic"
        static let italic           = "OpenSans-Italic"
        static let light            = "OpenSans-Light"
        static let lightItalic      = "OpenSans-LightItalic"
        static let regular          = "OpenSans"
        static let semibold         = "OpenSans-Semibold"
        static let semiboldItalic   = "OpenSans-SemiboldItalic"
        static let funkydori        = "UVFFunkydori"
    }
}
