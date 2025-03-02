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
    static let identifier = "ThumbnailCell"
    let disposeBag = DisposeBag()
    private var videoURLs: [String] = []
    let thumbnailTapped = PublishRelay<String>()
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let circleChannelImage: UIImageView = {
        let view = UIImageView()
        view.makeCornerRound(radius: 33)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("Class mate 님을 위한 클래스", attributes: .init(style: .headLine3, weight: .bold, textColor: .buttwink_gray200))
        label.numberOfLines = 1
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bindActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        circleChannelImage.image = nil
        videoURLs.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setLayout() {
        addSubview(imageView)
        imageView.addSubviews(titleLabel, bookmarkButton, circleChannelImage)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(188)
            make.width.equalTo(141)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(13)
        }
        circleChannelImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.bottom.equalTo(titleLabel.snp.top).offset(13)
        }
    }
    
    @objc private func onThumbnailTapped() {
        guard let videoURL = videoURLs.first else { return }
        thumbnailTapped.accept(videoURL)
    }
    
    private func bindActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onThumbnailTapped))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func configure(with videoItems: [UnifiedYoutubeEntity]) {
        guard let firstItem = videoItems.first,
              let videoThumbnailUrl = URL(string: firstItem.thumbnailUrl),
              let channelThumbnailUrl = URL(string: firstItem.channelThumbnailUrl ?? "") else {
            return
        }
        
        videoURLs = videoItems.compactMap { $0.videoId }
        
        imageView.kf.setImage(with: videoThumbnailUrl, options: [.transition(.fade(0.3)), .cacheOriginalImage]) { result in
            switch result {
            case .success(let value):
                print("Image successfully loaded: \(value.source)")
                print("Thumbnail URL: \(firstItem.thumbnailUrl)")
                print("Channel Thumbnail URL: \(firstItem.channelThumbnailUrl ?? "N/A")")
                
            case .failure(let error):
                print("Error loading image: \(error)")
                print("Thumbnail URL: \(firstItem.thumbnailUrl)")
                print("Channel Thumbnail URL: \(firstItem.channelThumbnailUrl ?? "N/A")")
                
            }
        }
        
        circleChannelImage.kf.setImage(with: channelThumbnailUrl, options: [.transition(.fade(0.3)), .cacheOriginalImage])
    }
    
}
