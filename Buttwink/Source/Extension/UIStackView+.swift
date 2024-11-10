//
//  UIStackView+.swift
//  Buttwink
//
//  Created by 고영민 on 11/11/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
