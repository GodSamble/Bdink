//
//  ThumbnailView.swift
//  Buttwink
//
//  Created by 고영민 on 11/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignSystem

final class ThumbnailView: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "ThumbnailView"
    private var bag = DisposeBag()
    
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
    
    public func configure(_ images: [UIImage?], _ count: Int) {
           // 첫 번째 이미지를 사용하는 예시
           if let img = images.first ?? nil {
               imageView.image = img
               titleLabel.text = "들어간다 \(count)"
               imageView.backgroundColor = .clear
           } else {
               imageView.image = UIImage(systemName: "sample")?.resizeWithWidth(width: 200)?.withTintColor(.buttwink_gray200)
               titleLabel.text = "000"
           }
       }
}
