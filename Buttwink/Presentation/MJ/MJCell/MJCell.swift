//
//  MJCell.swift
//  Buttwink
//
//  Created by 이명진 on 12/24/24.
//

import UIKit

import SnapKit

final class MJCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        label.text = "기본 텍스트"
        
        return label
    }()
    
    private let openDate: UILabel = {
        let label = UILabel()
        label.text = "기본 텍스트"
        return label
    }()
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MJCell {
    private func setHierarchy() {
        backgroundColor = .buttwink_gray200
        
        contentView.addSubviews(
            titleLabel,
            openDate
        )
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        openDate.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension MJCell {
    func bind(model: BoxOffice) {
        self.titleLabel.text = model.movieName
        self.openDate.text = model.openDate
    }
}
