//
//  File.swift
//  
//
//  Created by 고영민 on 11/22/24.
//

import Foundation

extension NSMutableAttributedString {
    public func appending(
        string: String,
        attributes: Typography.Attributes
    ) -> NSMutableAttributedString {
        let newText = Typography.build(string: string, attributes: attributes)
        append(newText)
        return self
    }
    public func appending(
        _ attributedString: NSMutableAttributedString
    ) -> NSMutableAttributedString {
        append(attributedString)
        return self
    }
}
