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
    
    var currentPage = 1
    var isLoading = false
    let itemsPerPage = 15
    
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
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
    
    private var bookmarkButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        previousThumbnail = nil
        thumbnail.removeAll()
        bag = DisposeBag() // RxSwift DisposeBag 재설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubview(imageView)
        imageView.addSubviews(titleLabel, bookmarkButton)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(366)
            make.width.equalTo(270)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(13)
        }

    }
    
    @objc
    func BookmarkTapped() {
        
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
