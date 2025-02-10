//
//  Thumbnail.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import UIKit

enum ButtonType {
    case WNGP, NABBA, NPC
    
    // from 메서드 추가
    static func from(_ tag: String) -> ButtonType {
        switch tag {
        case "NPC":
            return .NPC
        case "WNGP":
            return .WNGP
        case "NABBA":
            return .NABBA
        default:
            fatalError("Unknown tag: \(tag)")
        }
    }
}
