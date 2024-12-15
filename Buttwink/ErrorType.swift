//
//  ErrorType.swift
//  Buttwink
//
//  Created by 고영민 on 12/14/24.
//

import Foundation

enum ErrorType: String, Error {
    case disconnected = "UE1006"
    case parsingError
    case unknown
}
