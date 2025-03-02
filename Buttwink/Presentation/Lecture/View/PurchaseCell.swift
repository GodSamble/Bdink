//
//  PurchaseCell.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import UIKit
import RxSwift
import SnapKit
import DesignSystem

final class PurchaseCell: UICollectionViewCell {
    
    static let identifier = "PurchaseCell"
    
    private let normalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "정상가"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let discountPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "할인가"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .buttwink_gray0
        return label
    }()
    
    private let normalPriceNumLabel: UILabel = {
        let label = UILabel()
        label.text = "294,000"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let discountPriceNumLabel: UILabel = {
        let label = UILabel()
        label.text = "229,000"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .green
        return label
    }()
    
//    private let orLabel: UILabel = {
//        let label = UILabel()
//        label.text = "또는"
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        label.textColor = .buttwink_gray200
//        return label
//    }()
    
    private let purchaseAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let priceInfo1StackView = UIStackView()
    private let priceInfo2StackView = UIStackView()
    private let priceInfo3StackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        self.backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .buttwink_gray700
        divider.snp.makeConstraints { $0.height.equalTo(1) }
        return divider
    }
    
    private let redDivideView: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private func setupViews() {
        [priceInfo1StackView, priceInfo2StackView, priceInfo3StackView,
         purchaseAllButton, redDivideView].forEach {
            contentView.addSubview($0)
        }
        
        priceInfo1StackView.axis = .horizontal
        priceInfo1StackView.spacing = 4
        priceInfo1StackView.alignment = .center
        priceInfo1StackView.addArrangedSubview(normalPriceLabel)
        priceInfo1StackView.addArrangedSubview(createDivider())
        priceInfo1StackView.addArrangedSubview(normalPriceNumLabel)
        
        normalPriceNumLabel.addSubview(redDivideView)
        redDivideView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(normalPriceNumLabel.snp.width).inset(-4)
            make.height.equalTo(3)
        }
        
        priceInfo2StackView.axis = .horizontal
        priceInfo2StackView.spacing = 4
        priceInfo2StackView.alignment = .center
        priceInfo2StackView.addArrangedSubview(discountPriceLabel)
        priceInfo2StackView.addArrangedSubview(createDivider())
        priceInfo2StackView.addArrangedSubview(discountPriceNumLabel)
        
        priceInfo3StackView.axis = .horizontal
        priceInfo3StackView.spacing = 4
        priceInfo3StackView.alignment = .center
        priceInfo3StackView.addArrangedSubview(createDivider())
//        priceInfo3StackView.addArrangedSubview(orLabel)
        priceInfo3StackView.addArrangedSubview(createDivider())
    }

    private func setupConstraints() {
        priceInfo1StackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        priceInfo2StackView.snp.makeConstraints { make in
            make.top.equalTo(priceInfo1StackView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        purchaseAllButton.snp.makeConstraints { make in
            make.top.equalTo(priceInfo2StackView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(56)
        }
        
        priceInfo3StackView.snp.makeConstraints { make in
            make.top.equalTo(purchaseAllButton.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
