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

class ThumbnailView: BaseCollectionViewCell<Any> {
    static let identifier: String = "ThumbnailView"
    private var bag = DisposeBag()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override func layout() {
        [imageView].forEach { addSubview($0) }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.5) // 2:1 비율
        }

        
    }
//    override func bind() {
//        
//    }
}
