//
//  ThirdCell.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class ThirdCell: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "ThirdCell"
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
        label.setText("월 999만원 자동수익, 경제적 자유얻는 구체적 가이드 라인", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let makerLabel: UILabel = {
        let label = UILabel()
        label.setText("창업, 부업 | 선한부자 오가닉", attributes: .init(style: .detail, weight: .medium, textColor: .buttwink_gray0))
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
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
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(115) //130
            make.width.equalTo(154) // 174
        }
        
        self.imageView.addSubviews(bookmarkButton, titleLabel)
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(14)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        self.titleLabel.addSubview(makerLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.leading.equalToSuperview()
            make.width.equalTo(imageView.snp.width)
        }
        
        self.makerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview()
            make.width.equalTo(titleLabel.snp.width)
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
        
        // index 계산 시 count와 배열의 크기를 고려
        let imageIndex = min(count - 1, images.count - 1)
        let selectedImage = images[imageIndex]
        
        // 이미지 뷰에 이미지 설정
        self.imageView.image = selectedImage
    }
}
