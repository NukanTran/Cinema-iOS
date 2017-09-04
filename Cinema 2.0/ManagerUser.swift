//
//  ManagerUser.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/22/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyUserDefaults

class ManagerUser{
    static var user:User!
    static var idLocation = Defaults[.location]
    static var myLocation:CLLocation!{
        didSet{
            if idLocation.isEmpty{                
                let email = AppConstants.userName.isEmpty ? "-" : AppConstants.userName.replacingOccurrences(of: ".", with: "~")
                ManagerData.share.getCity(lat: myLocation.coordinate.latitude, log: myLocation.coordinate.longitude, email: email, success: { (idLocation) in
                    Defaults[.location] = idLocation
                    self.idLocation = idLocation
                    NotificationCenter.default.post(name: NSNotification.Name.locationChanged, object: nil)
                }) { (err) in
                    print(err)
                }
            }
        }
    }
}
