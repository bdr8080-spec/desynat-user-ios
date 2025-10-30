//
//  AppFont.swift
//  ChorApp
//
//  Created by Developer on 03/01/24.
//

import Foundation
import UIKit

extension UIFont {
    enum AppFont : String {
        case Montserrat_Black           = "Montserrat-Black"
        case Montserrat_Black_I         = "Montserrat-BlackItalic"
        
        case Montserrat_Bold            = "Montserrat-Bold"
        case Montserrat_Bold_I          = "Montserrat-BoldItalic"
        
        case Montserrat_ExtraBold       = "Montserrat-ExtraBold"
        case Montserrat_ExtraBold_I     = "Montserrat-ExtraBoldItalic"
        
        case Montserrat_ExtraLight      = "Montserrat-ExtraLight"
        case Montserrat_ExtraLight_I    = "Montserrat-ExtraLightItalic"
        
        case Montserrat_Italic          = "Montserrat-Italic"
        case Montserrat_Regular         = "Montserrat-Regular"
        
        case Montserrat_Light           = "Montserrat-Light"
        case Montserrat_LightItalic     = "Montserrat-LightItalic"
        
        case Montserrat_Medium          = "Montserrat-Medium"
        case Montserrat_Medium_I        = "Montserrat-MediumItalic"
        
        case Montserrat_SemiBold        = "Montserrat-SemiBold"
        case Montserrat_SemiBold_I      = "Montserrat-SemiBoldItalic"
        
        case Montserrat_Thin            = "Montserrat-Thin"
        case Montserrat_Thin_I          = "Montserrat-ThinItalic"
    }
    
    static func AppFontWith(name:AppFont, size:CGFloat) -> Self? {
        return self.init(name: name.rawValue, size: size)
    }
}
