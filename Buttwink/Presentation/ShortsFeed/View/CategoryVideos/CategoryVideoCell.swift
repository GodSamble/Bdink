//
//  CategoryVideoCell.swift
//  Buttwink
//
//  Created by 고영민 on 1/13/25.
//

import UIKit
import SnapKit
import DesignSystem

final class CategoryVideoCell: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "CategoryVideoCell"
    private var thumbnail: [UIImageView] = []
    var previousThumbnail: UIImageView? = nil
    
    var currentPage = 1
    var isLoading = false
    let itemsPerPage = 15
    
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 11
        view.image = .Sample.sample1
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.setText("25살에 1억을 모은 영상 구성 작가의 어쩌고 저쩌고", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.numberOfLines = 0 // 제한 없이 줄바꿈
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var subLabel: UILabel = {
        let label = UILabel()
        label.setText("창업 / 부업 | 에디터 영민쓰", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray200))
        label.numberOfLines = 1
        return label
    }()
    
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubviews(imageView, titleLabel, subLabel)
        imageView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        self.backgroundColor = .clear
    }
}
