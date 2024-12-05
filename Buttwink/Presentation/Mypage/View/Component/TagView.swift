//
//  TagView.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class TagView: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    static let identifier = "TagView"
    private var tagButtons: [UIButton] = []

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func configure(with tags: [String]) {
        tagButtons.forEach { $0.removeFromSuperview() }
        tagButtons.removeAll()
        
        var previousButton: UIButton? = nil

        for tag in tags {
            let tagButton = UIButton()
            tagButton.setTitle(tag, for: .normal)
            tagButton.setTitleColor(.white, for: .normal)
            tagButton.backgroundColor = .black
            tagButton.layer.cornerRadius = 8
            tagButton.layer.borderColor = UIColor.buttwink_gray600.cgColor
            tagButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            tagButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            
            contentView.addSubview(tagButton)
            tagButtons.append(tagButton)

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
