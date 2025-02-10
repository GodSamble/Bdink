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
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = .Sample.sample1
        view.backgroundColor = .white
        view.sizeToFit()
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
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
            make.height.equalTo(169)
            make.width.equalTo(169)
        }
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
