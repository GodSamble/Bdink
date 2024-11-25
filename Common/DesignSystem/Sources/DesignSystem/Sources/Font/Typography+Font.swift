//
//  File 2.swift
//  
//
//  Created by 고영민 on 11/22/24.
//

import UIKit


extension Typography {
    public enum Font {
        static var current: [ButtwinkFont] = [
            ButtwinkFont(name: .Pretendard, weight: .Medium, _extension: .otf),
            ButtwinkFont(name: .Pretendard, weight: .SemiBold, _extension: .otf),
            ButtwinkFont(name: .Pretendard, weight: .Bold, _extension: .otf)
        ]
        
        enum Name: String {
            case Pretendard
        }
        
        public enum Weight: String {
            case Bold
            case Medium
            case SemiBold
        }
        
        enum Extension: String {
            case otf
        }
    }
}


// MARK: - Register

extension Typography.Font {
    public static func register() {
        current.forEach {
            registerFont(fontName: $0.fileName, fontExtension: $0.extension)
        }
    }
    
    static func registerFont(fontName: String, fontExtension: String) {
        let bundle: Bundle = Bundle.module
        
        guard let fontURL = bundle.url(
            forResource: fontName,
            withExtension: fontExtension)
        else { fatalError("Couldn't find font \(fontName).\(fontExtension)") }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL)
        else { fatalError("Couldn't load data from the font \(fontName)") }
        
        guard let font = CGFont(fontDataProvider)
        else { fatalError("Couldn't create font from data") }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

extension Typography.Font {
    struct ButtwinkFont {
        private let name: Name
        private let weight: Weight
        private let _extension: Extension
        
        public init(name: Name, weight: Weight, _extension: Extension = .otf) {
            self.name = name
            self.weight = weight
            self._extension = _extension
        }
        
        var fileName: String {
            "\(name.rawValue)-\(weight.rawValue)"
        }
        
        var `extension`: String {
            _extension.rawValue
        }
    }
}

