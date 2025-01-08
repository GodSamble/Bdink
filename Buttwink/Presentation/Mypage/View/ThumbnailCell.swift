//
//  ThumbnailCell.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class ThumbnailCell: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "ThumbnailCell"
    private var bag = DisposeBag()
    private var thumbnail: [UIImageView] = []
    var previousThumbnail: UIImageView? = nil
    
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 8
        view.image = .Sample.sample1
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.setText("Class mate 님을 위한 클래스 ", attributes: .init(style: .headLine3, weight: .bold, textColor: .buttwink_gray200))
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
        self.addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(contentView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(13)
        }
    }
    
    public func configure(with images: [UIImage], with count: Int) {
        // 기존 thumbnail 뷰 제거
        thumbnail.forEach {
            $0.image = nil
            $0.removeFromSuperview()
        }
        thumbnail.removeAll()
        
        var previousThumbnail: UIImageView? = nil
        
        // 이미지 배열 처리
        for image in images {
            let uiimage = UIImageView()
            uiimage.backgroundColor = .blue
            uiimage.layer.cornerRadius = 8
            uiimage.image = image ?? .Sample.sample1  // 이미지가 nil인 경우 기본 이미지 설정
            uiimage.contentMode = .scaleAspectFill
            uiimage.clipsToBounds = true
            contentView.addSubview(uiimage)
            thumbnail.append(uiimage)
            
            // 레이아웃 제약 설정
            uiimage.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(contentView.snp.height)
                make.width.equalTo(271)  // 이미지의 너비를 명확히 설정 (필요에 따라 조정)
                if let previous = previousThumbnail {
                    make.left.equalTo(previous.snp.right).offset(8)
                } else {
                    make.left.equalToSuperview().offset(8)
                }
                previousThumbnail = uiimage
            }
        }
    }
}

