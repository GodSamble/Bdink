//
//  LectureHeaderView.swift
//  Buttwink
//
//  Created by 고영민 on 2/26/25.
//


import UIKit
import DesignSystem

enum HeaderType {
    case one // 구매하기
    case two // 리뷰
    case three // 클래스 안내
}

protocol LectureHeaderViewDelegate: AnyObject {
    func didTapHeaderButton()
}

final class LectureHeaderView: UICollectionReusableView {
    
    // MARK: - Property
    
    static let identifier = "LectureHeaderView"
    weak var delegate: LectureHeaderViewDelegate?
    
    // MARK: - UI Components
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.setText("Class mate 님을 위한 클래스 ", attributes: .init(style: .headLine2, weight: .bold, textColor: .buttwink_gray200))
        return label
    }()
    
    private var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.buttwink_gray400, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let image1: UIImageView = {
        let view = UIImageView()
        view.image = .Sample.sample1
        view.backgroundColor = .lightGray
        view.sizeToFit()
        view.makeCornerRound(radius: 70)
        return view
    }()
    
    private let image2: UIImageView = {
        let view = UIImageView()
        view.image = .Sample.sample1
        view.backgroundColor = .lightGray
        view.sizeToFit()
        view.makeCornerRound(radius: 70)
        return view
    }()
    
    private let image3: UIImageView = {
        let view = UIImageView()
        view.image = .Sample.sample1
        view.backgroundColor = .lightGray
        view.sizeToFit()
        view.makeCornerRound(radius: 70)
        return view
    }()
    
    private let image4: UIImageView = {
        let view = UIImageView()
        view.image = .Sample.sample1
        view.backgroundColor = .lightGray
        view.sizeToFit()
        view.makeCornerRound(radius: 70)
        return view
    }()
    
    func setupActions() {
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(headerType: HeaderType, rowCount: Int = 0, delegate: LectureHeaderViewDelegate?) {
        self.delegate = delegate
        
        switch headerType {
        case .one:
            setupOneCase()
            
        case .two:
            setupTwoCase()
            
        case .three:
            setupThreeCase()
        }
    }
    
    private func setupOneCase() {
        self.backgroundColor = .clear
        self.headerLabel.text = "구매하기"
        self.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupTwoCase() {
        self.backgroundColor = .clear
        self.headerLabel.text = "리뷰"
        self.moreButton.isHidden = false
        self.addSubviews(headerLabel, moreButton)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupThreeCase() {
        self.backgroundColor = .clear
        self.headerLabel.text = "클래스 안내"
        self.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
 
    @objc private func didTapMoreButton() {
        delegate?.didTapHeaderButton()
    }
    
    func didTapHeaderButton() {
        print("Header button tapped")
    }
}



