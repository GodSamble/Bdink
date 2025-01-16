////
////  BookmarkPosingVM.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BookmarkCodyVC: UIViewController, ViewModelBindableType {
//    
//    var viewModel: BookmarkCodyVM!
//    private let bag = DisposeBag()
//    
//    let refreshControl = UIRefreshControl()
//    
//    private let styleCollectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 1
//        flowLayout.minimumInteritemSpacing = 1
//        flowLayout.scrollDirection = .vertical
//        let width: CGFloat = (UIScreen.main.bounds.width - 24 - 2) / 3
//        let height: CGFloat = width * 4 / 3
//        flowLayout.itemSize = CGSize(width: width, height: height)
//        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.register(UINib(nibName: HomeMainCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeMainCell.identifier)
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
//            .map { _ in }
//            .asDriver(onErrorJustReturn: ())
//        let stylePagination = styleCollectionView.rx.prefetchItems.compactMap{ $0.last?.item }.asDriver(onErrorJustReturn: 0)
//        let styleModelSelected =
//        styleCollectionView.rx.modelSelected(HomeImageData.self).asDriver()
//        let refreshLoading = refreshControl.rx.controlEvent(.valueChanged)
//            .map{ _ in }.asDriver(onErrorJustReturn: ())
//        
//        let input = BookmarkCodyVM.Input(
//            viewWillAppear: viewWillAppear,
//            stylePagination: stylePagination,
//            styleModelSelected: styleModelSelected,
//            refreshLoading: refreshLoading)
//        let output = viewModel.transform(input: input)
//        [output.viewWillAppear.drive(),
//         output.pageChanged.drive(),
//         output.stylePagination.drive(),
//         output.styleModelSelected.drive(),
//         output.refreshLoading.drive(refreshControl.rx.isRefreshing)
//        ].forEach{ $0.disposed(by: bag) }
//        
//        viewModel.styleRelay.bind(to: styleCollectionView.rx.items(dataSource: viewModel.dataSource)).disposed(by: bag)
//    }
//    
//    private func layout(){
//        let safeArea = self.view.safeAreaLayoutGuide
//        
//        self.view.addSubview(styleCollectionView)
//        NSLayoutConstraint.activate([
//            styleCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            styleCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
//            styleCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
//            styleCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
//        ])
//    }
//    
//    private func configure(){
//        refreshControl.tintColor = .ableBlue
//        refreshControl.endRefreshing()
//        styleCollectionView.refreshControl = refreshControl
//    }
//    
//}
