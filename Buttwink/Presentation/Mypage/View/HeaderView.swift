//
//  HeaderView.swift
//  Buttwink
//
//  Created by 고영민 on 11/30/24.
//

import UIKit
import DesignSystem

final class HeaderView: UICollectionReusableView {
    
    static let identifier = "HeaderView"
    
    var closeButtonTappedClosure: (() -> Void)?
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.setText("Class mate 님을 위한 클래스 ", attributes: .init(style: .headLine2, weight: .bold, textColor: .buttwink_gray200))
        return label
    }()
    
    private var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.buttwink_gray400, for: .normal)
        button.addTarget(HeaderView.self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapMoreButton() {
        self.closeButtonTappedClosure?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        [headerLabel, moreButton].forEach { addSubview($0) }
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
