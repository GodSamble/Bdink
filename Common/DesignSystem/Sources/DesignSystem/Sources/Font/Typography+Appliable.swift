//
//  File.swift
//  
//
//  Created by 고영민 on 11/22/24.
//

import UIKit

public protocol TypographAppliable: AnyObject {
    var typography: NSAttributedString? { get set }
    
    func setText(
        _ string: String?,
        attributes: Typography.Attributes,
        customAttributes: [NSAttributedString.Key : Any]?
    )
}

extension TypographAppliable {
    public func setText(
        _ string: String?,
        attributes: Typography.Attributes,
        customAttributes: [NSAttributedString.Key : Any]? = nil
    ) {
        typography = Typography.build(
            string: string,
            attributes: attributes,
            customAttributes: customAttributes
        )
    }
}

extension UILabel: TypographAppliable {
    public var typography: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

extension UITextField: TypographAppliable {
    public var typography: NSAttributedString? {
        get { attributedText }
        set {
            attributedText = newValue
        }
    }
}

extension UITextView: TypographAppliable {
    public var typography: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

