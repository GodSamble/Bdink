////
////  BookmarkNewsVC.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//import RxDataSources
//
//class BookmarkItemVM: CommonViewModelType {
//    
//    let apiManager = MyAlamofireManager.shared
//    let user = OnBoardingUserInfo.shared
//    private let bag = DisposeBag()
//    
//    struct Input {
//        let viewWillAppear: Driver<Void>
//        let itemPagination: Driver<Int>
//        let itemModelSelected: Driver<ItemSimpleResDto>
//        let refreshLoading: Driver<Void>
//    }
//    
//    struct Output {
//        let viewWillAppear: Driver<Void>
//        let pageChanged: Driver<Void>
//        let itemPagination: Driver<Void>
//        let itemModelSelected: Driver<Void>
//        let refreshLoading: Driver<Bool>
//    }
//    
//    // page
//    let page = PublishSubject<Int>()
//    var currentPage: Int = 0
//    var isLastPage: Bool = false
//    let refreshLoading = PublishRelay<Bool>()
//    
//    // dataSource
//    var itemData: [ItemSimpleResDto] = []
//    let itemRelay = BehaviorRelay(value: [CommonSectionModel<ItemSimpleResDto>]())
//    let itemDataSource: RxCollectionViewSectionedReloadDataSource<CommonSectionModel<ItemSimpleResDto>> = {
//        let ds = RxCollectionViewSectionedReloadDataSource<CommonSectionModel<ItemSimpleResDto>>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemBoxMainCVC.identifier, for: indexPath) as? ItemBoxMainCVC else { return UICollectionViewCell() }
//            cell.bind(item)
////            cell.bookmark.isSelected = true
//            return cell
//        })
//         return ds
//     }()
//    
//    func transform(input: Input) -> Output {
//        let viewWillAppear = input.viewWillAppear
//            .do(onNext: { _ in
//                self.currentPage = 0
//                self.itemData.removeAll()
//                self.readBookmarkItem(page: 0, size: 20)
//            }).map{ _ in }.asDriver()
//        
//        let pageDriver = page
//            .do(onNext: { data in
//                self.readBookmarkItem(page: self.currentPage, size: 20)
//            }).map{ _ in }.asDriver(onErrorJustReturn: ())
//        
//        let itemPagination = input.itemPagination
//            .do { row in
//                guard row == self.itemData.count - 1 else { return }
//                if self.isLastPage == false {
//                    self.currentPage += 1
//                    self.page.onNext(self.currentPage)
//                }
//            }.map{ _ in }.asDriver()
//        
//        let itemModelSelected = input.itemModelSelected
//            .do { model in
//                guard let navi = UIApplication.shared.visibleViewController?.navigationController else { return }
//                let sb = UIStoryboard(name: "Home", bundle: nil)
//                let scene = sb.instantiateViewController(withIdentifier: "HomeItemVC") as! HomeItemVC
//                scene.viewModel = HomeItemViewModel(itemId: model.id, title: "")
//                navi.pushViewController(scene, animated: true)
//            }.map{ _ in }.asDriver()
//        
//        input.refreshLoading
//            .drive(onNext: { _ in
//                self.currentPage = 0
//                self.itemData.removeAll()
//                self.refreshLoading.accept(true)
//                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1){
//                    self.readBookmarkItem(page: self.currentPage, size: 20)
//                }
//            }).disposed(by: bag)
//        
//        return Output(viewWillAppear: viewWillAppear,
//                      pageChanged: pageDriver,
//                      itemPagination: itemPagination,
//                      itemModelSelected: itemModelSelected,
//                      refreshLoading: refreshLoading.asDriver(onErrorJustReturn: false))
//    }
//    
//    
//    private func readBookmarkItem(page: Int, size: Int){
//        apiManager.readBookmarkItem(page: page, size: size) { response in
//            switch response {
//            case .success(let data):
//                self.isLastPage = data.last
//                data.content.forEach{ self.itemData.append($0) }
//                self.itemRelay.accept([CommonSectionModel<ItemSimpleResDto>(model: 0, items: self.itemData)])
//                self.refreshLoading.accept(false)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}
