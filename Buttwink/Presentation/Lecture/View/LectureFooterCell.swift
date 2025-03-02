//
//  LectureFooterCell.swift
//  Buttwink
//
//  Created by 고영민 on 3/3/25.
//

import UIKit
import SnapKit
import DesignSystem

final class LectureFooterCell: UICollectionReusableView {
    static let identifier = "LectureFooterCell"
    
    private let footerButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(.Icon.next, for: .normal)
        return button
    }()
    
    private func setupButton() {
        footerButton.addTarget(self, action: #selector(didTapFooterButton), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapFooterButton() {
        print("클릭됨")
    }
    
    @objc
    private func didTapBookmarkButton() {
        print("클릭됨")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)  // ✅ UICollectionReusableView는 frame 기반 생성자 사용
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubviews(footerButton) // ✅ contentView 제거
        footerButton.addSubview(bookmarkButton)
        footerButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(56)
        }
        bookmarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(27)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}
