////
////  BaseCollectionView.swift
////  Buttwink
////
////  Created by 고영민 on 11/28/24.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BaseRxCollectionView<T>: UICollectionView {
//    
//    var bag = DisposeBag()
//
//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: frame, collectionViewLayout: layout)
//        setupCollectionView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        bag = DisposeBag()
//    }
//    
//    var items = [T]()
//    var dataRelay = BehaviorRelay(value: [CommonSectionModel<T>]())
//    
//    var model: [T]? {
//        didSet {
//            if let model = model {
//                bind(model)
//            }
//        }
//    }
//    
//    func setupCollectionView(){}
//    func bind(_ items: [T]){}
//    
//    var binder: Binder<[T]> {
//        return Binder(self) { view, data in
//            
//        }
//    }
//}
