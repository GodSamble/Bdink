//
//  NSObject+.swift
//  Buttwink
//
//  Created by 고영민 on 11/11/24.
//

import UIKit

extension NSObject {
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}
