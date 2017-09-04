//
//  Extentions.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/5/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import Foundation
import CryptoSwift

extension String{
    func toDate(stringFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        dateFormatter.locale = Locale.current
        if let date = dateFormatter.date(from: self){
            return date
        }
        return Date()
    }
    
    func htmlToText() -> String?
    {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    func toBase64()->String?{
        do{
            let aes = try AES(key: AppConstants.cryptoKey128, iv: AppConstants.cryptoKey128) // aes128
            let ciphertext = try aes.encrypt(Array(self.utf8))
            return ciphertext.toBase64()!
        } catch {
            return nil
        }
    }
    
    func base64ToString()->String?{
        do{
            let aes = try AES(key: AppConstants.cryptoKey128, iv: AppConstants.cryptoKey128) // aes128
            return try self.decryptBase64ToString(cipher: aes)
        } catch {
            return nil
        }
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension Date{
    func toString(stringFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self - (60*60*7))
    }
    
    func toRegion(_ region: Int)->Date{
        return self.addingTimeInterval(Double(region*60*60))
    }
}

extension UIColor{
    
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    open class var icon: UIColor { return #colorLiteral(red: 0.1497175097, green: 0.2198084593, blue: 0.2972394228, alpha: 1)}//UIColor(hex: "#607D8B") }
    open class var iconSelected: UIColor { return UIColor(hex: "#4CAF50")}//#colorLiteral(red: 0.9499981999, green: 0.6071184278, blue: 0, alpha: 1)}//#colorLiteral(red: 0.3058949113, green: 0.6871605515, blue: 0.5705808997, alpha: 1) }
    open class var text: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    open class var textAlpha: UIColor { return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    open class var background: UIColor { return #colorLiteral(red: 0.9397105575, green: 0.9363325238, blue: 0.9432385564, alpha: 1) }
    open class var backgroundAlpha: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.600080819) }
}

