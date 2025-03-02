//
//  HeadCell.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import UIKit
import RxSwift
import SnapKit
import DesignSystem

final class HeadCell: UICollectionViewCell {
    
    static let identifier = "HeadCell"
    
    private let thumbnailImage: UIImageView = {
        let view = UIImageView()
//        view.image = .Sample.sample1
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.makeCornerRound(radius: 12)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .buttwink_gray0
        label.numberOfLines = 0
        label.text = "월 999만원으로 자동수익 레츠고가보자고 수업 레츠고"
        return label
    }()
    
//    private var subscribeButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("> 구독으로 시작하기", for: .normal) // ✅ setTitle 사용
//        button.setTitleColor(.buttwink_gray0, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .regular)
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .blue
//        button.layer.cornerRadius = 4
//        return button
//    }()
    
    private var previewButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.feed, for: .normal)
        button.setTitleColor(.buttwink_gray400, for: .normal)
        return button
    }()
    
    private var previewLabel: UILabel = {
        let label = UILabel()
        label.setText("미리보기", attributes: .init(style: .body2, weight: .medium))
        label.textColor = .buttwink_gray400
        return label
    }()
    
    private let previewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.feed, for: .normal)
        button.setTitleColor(.buttwink_gray400, for: .normal)
        return button
    }()
    
    private var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.setText("1209381", attributes: .init(style: .detail, weight: .medium))
        label.textColor = .buttwink_gray400
        return label
    }()
    
    private let bookmarkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.feed, for: .normal)
        button.setTitleColor(.buttwink_gray400, for: .normal)
        return button
    }()
    
    private var shareLabel: UILabel = {
        let label = UILabel()
        label.setText("공유", attributes: .init(style: .body3, weight: .medium))
        label.textColor = .buttwink_gray400
        return label
    }()
    
    private let shareStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private let teacherImage: UIImageView = {
        let view = UIImageView()
//        view.image = .Sample.sample1
        view.backgroundColor = .lightGray
        view.sizeToFit()
        view.makeCornerRound(radius: 70)
        return view
    }()
    
    private let teacherNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.setText("고영민티쳐", attributes: .init(style: .body, weight: .bold))
        label.textColor = .buttwink_gray0
        return label
    }()
    
    private let kindOfLectureLabel: UILabel = {
        let label = UILabel()
        label.setText("영양", attributes: .init(style: .body, weight: .medium))
        label.textColor = .lightGray
        return label
    }()
    
    private let kindOfLectureImage: UIImageView = {
        let view = UIImageView()
        view.image = .Icon.mypage
        view.backgroundColor = .buttwink_gray400
        view.sizeToFit()
        return view
    }()
    
    private let learningTimeLabel: UILabel = {
        let label = UILabel()
        label.setText("챕터10개", attributes: .init(style: .body, weight: .medium))
        label.textColor = .lightGray
        return label
    }()
    
    private let learningTimeImage: UIImageView = {
        let view = UIImageView()
        view.image = .Icon.mypage
        view.backgroundColor = .white
        view.sizeToFit()
        return view
    }()
    
    private let lectureInfo1StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    private let lectureInfo2StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 29
        stackView.alignment = .center
        return stackView
    }()
    private let lectureInfo3StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.spacing = 14
        stackView.alignment = .fill
        
        return stackView
    }()
    private let lectureInfo4StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        self.backgroundColor = .black
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {

        previewStackView.addArrangedSubview(previewLabel)
        previewStackView.addArrangedSubview(previewButton)
        bookmarkStackView.addArrangedSubview(bookmarkLabel)
        bookmarkStackView.addArrangedSubview(bookmarkButton)
        shareStackView.addArrangedSubview(shareLabel)
        shareStackView.addArrangedSubview(shareButton)
        
        contentView.addSubviews(lectureInfo1StackView, lectureInfo2StackView, lectureInfo3StackView, lectureInfo4StackView)
        
        
        lectureInfo1StackView.addArrangedSubview(thumbnailImage)
        thumbnailImage.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(210)
        }
        lectureInfo1StackView.addArrangedSubview(titleLabel)
//        lectureInfo1StackView.addArrangedSubview(subscribeButton)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(thumbnailImage.snp.width)

        }
//        subscribeButton.snp.makeConstraints { make in
//            make.width.equalTo(366)
//            make.height.equalTo(39)
//        }
        
        
        lectureInfo2StackView.addArrangedSubview(previewStackView)
        lectureInfo2StackView.addArrangedSubview(bookmarkStackView)
        lectureInfo2StackView.addArrangedSubview(shareStackView)
        
        
        lectureInfo3StackView.addArrangedSubview(teacherImage)
        teacherImage.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.leading.equalToSuperview().inset(10)
        }
        lectureInfo3StackView.addArrangedSubview(teacherNicknameLabel)
        
        
        lectureInfo4StackView.addArrangedSubview(kindOfLectureImage)
        lectureInfo4StackView.addArrangedSubview(learningTimeImage)
        
        kindOfLectureImage.addSubview(kindOfLectureLabel)
        kindOfLectureImage.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
        kindOfLectureLabel.snp.makeConstraints { make in
            make.leading.equalTo(kindOfLectureImage.snp.trailing)
            make.centerY.equalToSuperview()
        }
        learningTimeImage.addSubview(learningTimeLabel)
        learningTimeImage.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        learningTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(learningTimeImage.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        lectureInfo1StackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(15)
            
        }
        
        lectureInfo2StackView.snp.makeConstraints { make in
            make.top.equalTo(lectureInfo1StackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        lectureInfo3StackView.snp.makeConstraints { make in
            make.top.equalTo(lectureInfo2StackView.snp.bottom).offset(19)
            make.leading.equalToSuperview()
        }
        
        lectureInfo4StackView.snp.makeConstraints { make in
            make.top.equalTo(lectureInfo3StackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
    }
    
    
}
