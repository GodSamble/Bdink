//
//  LectureCell.swift
//  Buttwink
//
//  Created by 고영민 on 2/17/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class LectureCell: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "LectureCell"
    private var bag = DisposeBag()
    private var isBookmarked = BehaviorRelay<Bool>(value: false)
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = .Sample.sample1
        view.backgroundColor = .white
        view.sizeToFit()
        return view
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(.Btn.floating, for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("여성의 골반과 고관절 어쩌구", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let maker_totalLectureNum_Label: UILabel = {
        let label = UILabel()
        label.setText("지니킴 교수님 | 총 16강", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.setText("20%", attributes: .init(style: .detail, weight: .medium, textColor: .red))
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.setText("월 66,700원", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let period_reviewNum_Label: UILabel = {
        let label = UILabel()
        label.setText("(3개월) | 리뷰수(23)", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let lectureInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bindActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        
        self.addSubview(imageView)
        self.imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(110)
            make.width.equalTo(200)
        }
        
        lectureInfoStackView.addArrangedSubview(discountLabel)
        lectureInfoStackView.addArrangedSubview(priceLabel)
        lectureInfoStackView.addArrangedSubview(period_reviewNum_Label)
        
        self.addSubviews(bookmarkButton, titleLabel, maker_totalLectureNum_Label, lectureInfoStackView)
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).inset(12)
            make.trailing.equalTo(imageView.snp.trailing).inset(14)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.leading.equalTo(imageView.snp.leading)
            make.width.equalTo(imageView.snp.width)
        }
        
        maker_totalLectureNum_Label.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(imageView.snp.leading)
            make.width.equalTo(titleLabel.snp.width)
        }
        
        lectureInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading)
            make.top.equalTo(maker_totalLectureNum_Label.snp.bottom).offset(10)
        }
    }
    
    private func bindActions() {
        // 북마크 버튼 상태에 따라 이미지 변경
        isBookmarked
            .map { $0 ? UIImage(named: "bookmark_selected") : UIImage(named: "bookmark_unselected") }
            .bind(to: bookmarkButton.rx.image(for: .normal))
            .disposed(by: bag)
        
        // 버튼 클릭 시 북마크 상태 토글
        bookmarkButton.rx.tap
            .withLatestFrom(isBookmarked)
            .map { !$0 } // 상태 반전
            .bind(to: isBookmarked)
            .disposed(by: bag)
    }
    
    
    public func configure(with images: [UIImage], with count: Int) {
        guard !images.isEmpty, count > 0 else {
            print("No images to configure.")
            return
        }
        let imageIndex = min(count - 1, images.count - 1)
        let selectedImage = images[imageIndex]
        self.imageView.image = selectedImage
    }
}
