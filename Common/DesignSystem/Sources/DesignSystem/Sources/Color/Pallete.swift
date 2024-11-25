//
//  File.swift
//  
//
//  Created by 고영민 on 11/22/24.
//

import UIKit

enum Pallete: String {
    case gray0
    case gray50
    case gray100
    case gray200
    case gray300
    case gray400
    case gray500
    case gray600
    case gray700
    case gray750
    case gray800
    case gray900
    
    case green50
    case green100
    case green150
    case green200
    case green300
    case green400
    case green500
    case green600
    case green700
    case green800
    case green850
    case green900
    case green950
}

extension UIColor {
    
    convenience init(pallete: Pallete) {
        self.init(named: pallete.rawValue, in: Bundle.module, compatibleWith: nil)!
    }
}
