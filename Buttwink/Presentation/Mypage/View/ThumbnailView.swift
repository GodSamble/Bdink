//
//  ThumbnailView.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class ThumbnailView: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "ThumbnailView"
    private var bag = DisposeBag()
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.image = .Sample.sample1
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.setText("Class mate 님을 위한 클래스 ", attributes: .init(style: .headLine3, weight: .bold, textColor: .buttwink_gray200))
        label.numberOfLines = 1
        return label
    }()
    
    private var subLabel: UILabel = {
    let label = UILabel()
        label.setText("Class mate 님을 위한 클래스 ", attributes: .init(style: .headLine3, weight: .bold, textColor: .buttwink_gray200))
        label.numberOfLines = 1
    return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods

    private func setLayout() {
        [imageView].forEach { addSubview($0) }
        imageView.addSubview(titleLabel)
        imageView.addSubview(subLabel)
        
        imageView.addSubviews(titleLabel, subLabel)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {make in
            make.leading.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(44)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(14)
        }
    }
}
