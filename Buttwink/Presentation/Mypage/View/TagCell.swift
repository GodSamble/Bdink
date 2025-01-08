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
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with tagViewModel: [String]) {
        // 기존 버튼들을 모두 제거
        tagButtons.forEach { $0.removeFromSuperview() }
        tagButtons.removeAll()
        
        var previousButton: UIButton? = nil
        
        // tagViewModel의 tags 배열을 사용하여 버튼 생성
        for tag in tagViewModel {
            let tagButton = UIButton()
            tagButton.setTitle(tag, for: .normal) // 서버에서 받은 name을 버튼 텍스트로 설정
            tagButton.setTitleColor(.white, for: .normal)
            tagButton.backgroundColor = .black
            tagButton.layer.cornerRadius = 8
            tagButton.layer.borderColor = UIColor.buttwink_gray600.cgColor
            tagButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            contentView.addSubview(tagButton)
            tagButtons.append(tagButton)
            
            // 레이아웃 설정
            tagButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(30)
                if let previous = previousButton {
                    make.left.equalTo(previous.snp.right).offset(8)
                } else {
                    make.left.equalToSuperview().offset(8)
                }
            }
            previousButton = tagButton
        }
    }
}

