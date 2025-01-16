////
////  BookmarkNewsVM.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BookmarkItemVC: UIViewController, ViewModelBindableType {
//    
//    var viewModel: BookmarkItemVM!
//    private let bag = DisposeBag()
//    
//    let refreshControl = UIRefreshControl()
//    
//    private let itemCollectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 18
//        flowLayout.scrollDirection = .vertical
//        let width: CGFloat = UIScreen.main.bounds.width / 2
//        let height: CGFloat = width * (335 / 195)
//        flowLayout.itemSize = CGSize(width: width, height: height)
//        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.register(ItemBoxMainCVC.self, forCellWithReuseIdentifier: ItemBoxMainCVC.identifier)
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        layout()
//        configure()
//    }
//    
//    func bindViewModel() {
//        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
//            .map{ _ in }.asDriver(onErrorJustReturn: ())
//        let itemPagination = itemCollectionView.rx.prefetchItems.compactMap{ $0.last?.item }.asDriver(onErrorJustReturn: 0)
//        
//        let itemModelSelected =
//        itemCollectionView.rx.modelSelected(CommonSectionModel<ItemSimpleResDto>.Item.self).asDriver()
//        let refreshLoading = refreshControl.rx.controlEvent(.valueChanged)
//            .map{ _ in }.asDriver(onErrorJustReturn: ())
//        let input = BookmarkItemVM.Input(
//            viewWillAppear: viewWillAppear,
//            itemPagination: itemPagination,
//            itemModelSelected: itemModelSelected,
//            refreshLoading: refreshLoading)
//        let output = viewModel.transform(input: input)
//        [output.viewWillAppear.drive(),
//         output.pageChanged.drive(),
//         output.itemPagination.drive(),
//         output.itemModelSelected.drive(),
//         output.refreshLoading.drive(refreshControl.rx.isRefreshing)
//        ].forEach{ $0.disposed(by: bag) }
//        
//        viewModel.itemRelay.bind(to: itemCollectionView.rx.items(dataSource: viewModel.itemDataSource)).disposed(by: bag)
//        
//    }
//    
//    private func layout(){
//        self.view.addSubview(itemCollectionView)
//        NSLayoutConstraint.activate([
//            itemCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            itemCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            itemCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            itemCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
//    }
//    
//    private func configure(){
//        refreshControl.tintColor = .ableBlue
//        refreshControl.endRefreshing()
//        itemCollectionView.refreshControl = refreshControl
//    }
//    
//}
