//
//  Encodable.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation

extension Encodable {
    
    func asParameter() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
