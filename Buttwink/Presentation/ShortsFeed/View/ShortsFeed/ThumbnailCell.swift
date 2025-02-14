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
import Kingfisher

final class ThumbnailCell: BaseCollectionViewCell<Any> {
    
    // MARK: - Property
    
    static let identifier: String = "ThumbnailCell"
    private var bag = DisposeBag()
    var thumbnail: UIImageView? = nil
    var previousThumbnail: UIImageView? = nil
    
    var currentPage = 1
    var isLoading = false
    let itemsPerPage = 15
    
    var items: [String] = []
    private var thumbnailImageViews: [UIImageView] = []
    
    
    // MARK: - UI Components
    
    let imageView: UIImageView = {
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
        imageView.kf.cancelDownloadTask() // 기존 이미지 다운로드 취소
        previousThumbnail = nil
        //        thumbnail.removeAll()
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
    
    func configure(with videoItems: [Entity_YoutubeData], with count: Int) {
        // URL 배열 생성 (최대 10개까지만 가져오기)
        let urls = videoItems.prefix(10).compactMap { $0.thumbnailUrl }
        
        var previousView: UIImageView? = nil
        
        for urlString in urls {
            guard let url = URL(string: urlString) else {
                print("⚠️ 잘못된 URL: \(urlString)")
                continue
            }
            
            let imageView = UIImageView()
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            ) { result in
                switch result {
                case .success(let value):
                    print("✅ 이미지 로드 성공: \(value.source.url?.absoluteString ?? "알 수 없음")")
                case .failure(let error):
                    print("❌ 이미지 로드 실패: \(error.localizedDescription)")
                }
            }
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(imageView)
            thumbnailImageViews.append(imageView)
            
            // 오토레이아웃 설정
            imageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.edges.equalToSuperview()
            }
            
            previousView = imageView
        }
        
        // 아이템 URL 저장
        items = urls
        
        
    }
}
