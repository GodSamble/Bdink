//
//  TagCell.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class TagCell: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    static let identifier = "TagCell"
    private var tagButtons: [UIButton] = []
    let buttonTapSubject = PublishSubject<ButtonType>()
    
    var disposeBag = DisposeBag()
    
    private let tagButton: UIButton = {
        let button = UIButton()
        button.setTitle("dkd", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.buttwink_gray500.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return button
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
    func configure(with tags: [String], with count: Int) {
        // 태그 인덱스 계산
        let tagsIndex = min(count - 1, tags.count - 1)
        let dynamicTag = tags[tagsIndex]
        
        // 버튼 제목 설정
        self.tagButton.setTitle("\(dynamicTag)", for: .normal)
        
        // 버튼 탭 이벤트 연결
        tagButton.rx.tap
            .map { ButtonType.from(dynamicTag) } // 단일 태그를 기반으로 ButtonType 생성
            .bind(to: buttonTapSubject)
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.addSubview(tagButton)
        tagButton.snp.makeConstraints {make in
            
            make.leading.equalToSuperview().offset(0) // 왼쪽 여백
            make.trailing.equalToSuperview().offset(-8) // 오른쪽 여백
            make.top.equalToSuperview().offset(4) // 위 여백
            make.bottom.equalToSuperview().offset(-4) // 아래 여백
            make.height.equalTo(33).priority(.low)
        }
    }
    
    func onButtonTapped(buttonType: ButtonType) {
        buttonTapSubject.onNext(buttonType)
    }
}

