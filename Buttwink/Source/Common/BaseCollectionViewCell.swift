//
//  BaseCollectionViewCell.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//

import UIKit

class BaseCollectionViewCell<T>: UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: T? {
        didSet {
            if let model = model {
                bind(model)
            }
        }
    }

    func layout() {}
    func bind(_ item: T) {}
    
}
