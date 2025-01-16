////
////  BookmarkCell.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BookmarkItemCell: UICollectionViewCell {
//    
//    static let identifier: String = "BookmarkItemCell"
//    static let nib: UINib = UINib(nibName: "BookmarkItemCell", bundle: nil)
//    var bag = DisposeBag()
//    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    private let brandName: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let itemName: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .darkGray
//        return label
//    }()
//    
//    private let netPrice: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        label.textColor = .red
//        return label
//    }()
//    
//    private let fullPrice: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        label.textColor = .lightGray
//        return label
//    }()
//    
//    private let discountRate: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        label.textColor = .red
//        return label
//    }()
//    
//    private let isPlural: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true
//        return imageView
//    }()
//    
//    private let bookmark: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "bookmark"), for: .normal)
//        button.setImage(UIImage(named: "able.bookmark.fill"), for: .selected)
//        return button
//    }()
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        reset()
//    }
//    
//    private func reset() {
//        bag = DisposeBag()
//    }
//    
//    func bind(_ item: FindItem) {
//        configure()
//        imageView.setImage(urlString: item.image)
//        brandName.text = item.brandName
//        itemName.text = item.name
//        if let salePrice = item.salePrice {
//            fullPrice.setMiddleline(price: item.price) /// 줄 긋기
//            netPrice.text = salePrice.toPrice()
//            discountRate.text = getDiscoutRate(fullPrice: item.price, netPrice: salePrice)
//            fullPrice.isHidden = false
//            discountRate.isHidden = false
//        } else {
//            netPrice.text = item.price.toPrice()
//            fullPrice.isHidden = true
//            discountRate.isHidden = true
//        }
//        switch item.plural {
//        case true:
//            isPlural.isHidden = false
//        case false:
//            isPlural.isHidden = true
//        }
//        
//        bookmark.rx.tap.throttle(.milliseconds(300),latest: false, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { _ in
//                if self.bookmark.isSelected {
//                    MyAlamofireManager.shared.deleteBookmarkItem(itemId: item.id) { response in
//                        switch response {
//                        case .success(_):
//                            self.bookmark.isSelected = !self.bookmark.isSelected
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                } else {
//                    MyAlamofireManager.shared.addBookmarkItem(itemId: item.id) { response in
//                        switch response {
//                        case .success(_):
//                            self.bookmark.isSelected = !self.bookmark.isSelected
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                }
//            }).disposed(by: bag)
//    }
//    
//    private func configure(){
//        bookmark.setImage(UIImage(named: "bookmark"), for: .normal)
//        bookmark.setImage(UIImage(named: "able.bookmark.fill"), for: .selected)
//    }
//    
//    private func getDiscoutRate(fullPrice: Int, netPrice: Int) -> String {
//        let ratio = Double(fullPrice - netPrice) / Double(fullPrice)
//        let percent = ratio * 100
//        let ceilPercent = Int(percent.rounded())
//        
//        return "\(ceilPercent)%"
//    }
//}
