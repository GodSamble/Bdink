////
////  ItemBoxMainCVC.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//
//class ItemBoxMainCVC: BaseCollectionViewCell<ItemSimpleResDto> {
//    static let identifier: String = "ItemBoxMainCVC"
//    private var bag = DisposeBag()
//    
//    private let imageView: UIImageView = {
//        let view = UIImageView()
//        return view
//    }()
//    
//    private let bookmarkButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "bookmark"), for: .normal)
//        button.setImage(UIImage(named: "able.bookmark.fill"), for: .selected)
//        return button
//    }()
//    
//    private let brandName: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.getCustomFont(font: .CJKkr, weight: .Bold, size: 10)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let itemName: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.getCustomFont(font: .CJKkr, weight: .Regular, size: 12)
//        label.textColor = .ableDark
//        return label
//    }()
//    
//    private let priceStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .horizontal
//        view.spacing = 5
//        return view
//    }()
//    
//    private let netPrice: UILabel = { // 판매가
//        let label = UILabel()
//        label.font = UIFont.getCustomFont(font: .CJKkr, weight: .Bold, size: 12)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let discountRate: UILabel = { // 할인율
//        let label = UILabel()
//        label.font = UIFont.getCustomFont(font: .CJKkr, weight: .Bold, size: 12)
//        label.textColor = .ableBlue
//        return label
//    }()
//    
//    private let isPlural: UIImageView = { // 사진 복수개 여부
//        let view = UIImageView()
//        view.image = UIImage(named: "able.squareMultiple")
//        return view
//    }()
//    
//    private let verticalStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 8
//        view.alignment = .leading
//        view.distribution = .equalSpacing
//        return view
//    }()
//    
//    private let isCouponApplicable: UILabel = { // 쿠폰 사용 가능 여부
//        let label = UILabel()
//        label.font = UIFont.getCustomFont(font: .CJKkr, weight: .Medium, size: 9)
//        label.textColor = .deep
//        label.backgroundColor = .planeGrey
//        label.clipsToBounds = true
//        label.layer.cornerRadius = 2
//        label.text = "쿠폰"
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private let avgStarRating: UIButton = { // 별점
//        let button = UIButton()
//        button.setTitleColor(.smallTextGrey, for: .normal)
//        button.titleLabel?.font = UIFont.getCustomFont(font: .CJKkr, weight: .Regular, size: 10)
//        button.contentVerticalAlignment = .center
//        return button
//    }()
//    
//    private let indexLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.getCustomFont(font: .CJKkr, weight: .Medium, size: 12)
//        label.textColor = .white
//        label.backgroundColor = .ableDark
//        label.layer.cornerRadius = 5
//        label.clipsToBounds = true
//        label.textAlignment = .center
//        label.isHidden = true
//        return label
//    }()
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        bag = DisposeBag()
//    }
//    
//    override func layout() {
//        [imageView, bookmarkButton, brandName, itemName, priceStackView, verticalStackView].forEach{ addSubview($0) }
//        imageView.addSubview(indexLabel)
//        imageView.addSubview(isPlural)
//        [discountRate, netPrice].forEach{ priceStackView.addArrangedSubview($0) }
//        [isCouponApplicable, avgStarRating].forEach{
//            verticalStackView.addArrangedSubview($0)
//        }
//        
//        let width = UIScreen.current.bounds.width / 2
//        imageView.snp.makeConstraints { make in
//            make.leading.top.trailing.equalToSuperview()
//            make.height.equalTo(width)
//        }
//        indexLabel.snp.makeConstraints { make in
//            make.leading.top.equalToSuperview().offset(8)
//            make.width.height.equalTo(25)
//        }
//        isPlural.snp.makeConstraints { make in
//            make.width.height.equalTo(24)
//            make.top.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-10)
//        }
//        brandName.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(12)
//            make.top.equalTo(imageView.snp.bottom).offset(11.53)
//            make.trailing.equalTo(bookmarkButton.snp.leading)
//            make.height.equalTo(15)
//        }
//        bookmarkButton.snp.makeConstraints { make in
//            make.width.equalTo(19)
//            make.height.equalTo(20.77)
//            make.centerY.equalTo(brandName.snp.centerY)
//            make.trailing.equalToSuperview().offset(-12)
//        }
//        itemName.snp.makeConstraints { make in
//            make.leading.equalTo(brandName.snp.leading)
//            make.top.equalTo(brandName.snp.bottom).offset(4.53)
//            make.trailing.equalToSuperview().offset(-12)
//            make.height.equalTo(18)
//        }
//        priceStackView.snp.makeConstraints { make in
//            make.leading.equalTo(brandName.snp.leading)
//            make.trailing.equalToSuperview().offset(-12)
//            make.top.equalTo(itemName.snp.bottom).offset(4)
//            make.height.equalTo(18)
//        }
//        
//        verticalStackView.snp.makeConstraints { make in
//            make.leading.equalTo(brandName.snp.leading)
//            make.top.equalTo(priceStackView.snp.bottom).offset(8)
//            make.bottom.lessThanOrEqualToSuperview().offset(-22.94)
//        }
//        
//        isCouponApplicable.snp.makeConstraints { make in
//            make.width.equalTo(27)
//            make.height.equalTo(15)
//        }
//        avgStarRating.snp.makeConstraints { make in
//            make.height.equalTo(15)
//        }
//    }
//    
//    override func bind(_ item: ItemSimpleResDto) {
//        imageView.setImage(urlString: item.image)
//        brandName.text = item.brandName
//        itemName.text = item.name
//        // 가격 표시
//        if let salePrice = item.salePrice {
//            netPrice.text = salePrice.toPrice()
//            discountRate.text = item.price.getDiscoutRate(netPrice: salePrice)
//            discountRate.isHidden = false
//        } else {
//            netPrice.text = item.price.toPrice()
//            discountRate.isHidden = true
//        }
//        // 복수개 이미지 아이콘
//        switch item.plural {
//        case true:
//            isPlural.isHidden = false
//        case false:
//            isPlural.isHidden = true
//        }
//        // 별점
//        if let startRating = item.avgStarRating {
//            avgStarRating.setImage(UIImage(named: "able.star.small"), for: .normal)
//            avgStarRating.setTitle(startRating, for: .normal)
//            avgStarRating.isHidden = false
//        } else {
//            avgStarRating.isHidden = true
//            avgStarRating.setImage(nil, for: .normal)
//            avgStarRating.setTitle("", for: .normal)
//        }
//        // 북마크
//        switch item.bookmarked {
//        case true:
//            bookmarkButton.isSelected = true
//        case false:
//            bookmarkButton.isSelected = false
//        }
//        // 쿠폰
//        switch item.couponApplicable {
//        case true:
//            isCouponApplicable.isHidden = false
//        case false:
//            isCouponApplicable.isHidden = true
//        }
//        bookmarkAction(item)
//    }
//    
//    public func bind(_ item: ItemSimpleResDto, _ index: Int){
//        self.bind(item)
//        indexLabel.isHidden = false
//        indexLabel.text = String(index + 1)
//    }
//    
//    private func bookmarkAction(_ item: ItemSimpleResDto){
//        self.bookmarkButton.rx.tap.throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { _ in
//                if self.bookmarkButton.isSelected {
//                    MyAlamofireManager.shared.deleteBookmarkItem(itemId: item.id) { response in
//                        switch response {
//                        case .success(_):
//                            self.bookmarkButton.isSelected = !self.bookmarkButton.isSelected
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                } else {
//                    MyAlamofireManager.shared.addBookmarkItem(itemId: item.id) { response in
//                        switch response {
//                        case .success(_):
//                            self.bookmarkButton.isSelected = !self.bookmarkButton.isSelected
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                }
//            }).disposed(by: bag)
//    }
//    
//    
//}
