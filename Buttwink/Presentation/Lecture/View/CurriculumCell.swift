//
//  CurriculumCell.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import UIKit
import RxSwift
import SnapKit
import DesignSystem

final class CurriculumCell: UICollectionViewCell {
    
    static let identifier = "CurriculumCell"
    
    // 고정된 텍스트를 설정
    let fixedTitles = [
        "몇 날 며칠까지 열람 가능",
        "총 챕터 수",
        "총 시간"
    ]
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private let images: [UIImageView] = [
        UIImageView(image: .Icon.apple),
        UIImageView(image: .Icon.feed),
        UIImageView(image: .Icon.feed)
    ]
    
    private var classInfoStackViews: [UIStackView] = []
    private let titles: [UILabel] = [
        UILabel(),
        UILabel(),
        UILabel()
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImages()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 🔥 여기 추가
        imageStackView.isHidden = true
        contentsStackView.isHidden = false
    }
    
//    private func setupImages() {
//        [image1, image2, image3].forEach {
//            $0.backgroundColor = .white
//            $0.contentMode = .scaleAspectFit
//            $0.makeCornerRound(radius: 33)
//            imageStackView.addArrangedSubview($0)
//        }
//    }
    
    private func setupImages() {
        classInfoStackViews = [UIStackView(), UIStackView(), UIStackView()]
        

        for (index, stackView) in classInfoStackViews.enumerated() {
            stackView.axis = .horizontal
            stackView.spacing = 4
            stackView.alignment = .leading
            setupImageAndTitle(for: index, in: stackView)
            imageStackView.addArrangedSubview(stackView)
        }
    }
    private func setupImageAndTitle(for index: Int, in stackView: UIStackView) {
        let imageView = images[index]
        let titleLabel = titles[index]
        
        // 이미지 설정
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.makeCornerRound(radius: 33)
        
        // 고정된 텍스트 설정
        titleLabel.setText(fixedTitles[index], attributes: .init(style: .body2, weight: .medium)) // 여기서 인덱스를 사용
        titleLabel.textColor = .white
        
        // 스택뷰에 이미지와 타이틀 추가
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, contentsStackView, imageStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        contentsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(title: String, contents: [String], isImageSection: Bool) {
        titleLabel.text = title
        imageStackView.isHidden = !isImageSection
        contentsStackView.isHidden = isImageSection
        
//        let dynamicTitles = [
//            "\(day)날 며칠까지 열람 가능",
//            "총 \(numberOfChapter)챕터 수",
//            "총 \(times)시간"
//        ]
        
        print("✅ [\(title)] isImageSection: \(isImageSection)")

        if !isImageSection {
            contentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            contents.forEach { text in
                let label = UILabel()
                label.font = .systemFont(ofSize: 14, weight: .medium)
                label.textColor = .darkGray
                label.text = text
                contentsStackView.addArrangedSubview(label)
            }
        }
    }


}
