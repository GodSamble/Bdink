//
//  ReviewCell.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import UIKit
import RxSwift
import SnapKit
import DesignSystem

final class ReviewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCell"
    
    private let headLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.setText("강의를, 이렇게 들었어요", attributes: .init(style: .body, weight: .bold))
        label.textColor = .buttwink_gray0
        label.textColor = .label
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "영민쓰"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .buttwink_gray0
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "경제적어쩌구그래서어라 라라라라 앙아아아 라랄라라 라라라하하하하하하하하하하하하하하하하하하"
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .buttwink_gray0
        return label
    }()
    
    private let iconImage: UIImageView = {
        let view = UIImageView()
        view.image = .Icon.pen
        view.backgroundColor = .white
        view.sizeToFit()
        view.makeCornerRound(radius: 33)
        return view
    }()
    
    private let userImage: UIImageView = {
        let view = UIImageView()
//        view.image = .Sample.sample1
        view.backgroundColor = .white
        view.sizeToFit()
        view.makeCornerRound(radius: 33)
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        self.backgroundColor = .black
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
       
        contentView.backgroundColor = .lightGray
        contentView.addSubviews(nicknameLabel, reviewLabel, iconImage, userImage)
    

        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(15)
            make.width.height.equalTo(22)
        }
        self.reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.equalTo(contentView.snp.width).inset(20)
            make.centerX.equalToSuperview()
        }
        
        self.userImage.snp.makeConstraints { make in
            make.leading.equalTo(iconImage.snp.leading)
            make.bottom.equalToSuperview().inset(5)
            make.width.height.equalTo(22)
        }
        self.nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImage.snp.trailing).offset(5)
            make.centerY.equalTo(userImage)
        }
    }
}
