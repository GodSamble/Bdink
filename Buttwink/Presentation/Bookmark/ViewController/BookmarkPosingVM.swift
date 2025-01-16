////
////  BookmarkPosingVC.swift
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
//class BookmarkCodyVM: CommonViewModelType {
//    
//    let apiManager = MyAlamofireManager.shared
//    let user = OnBoardingUserInfo.shared
//    private let bag = DisposeBag()
//    
//    struct Input {
//        let viewWillAppear: Driver<Void>
//        let stylePagination: Driver<Int>
//        let styleModelSelected: Driver<HomeImageData>
//        let refreshLoading: Driver<Void>
//    }
//    
//    struct Output {
//        let viewWillAppear: Driver<Void>
//        let pageChanged: Driver<Void>
//        let stylePagination: Driver<Void>
//        let styleModelSelected: Driver<Void>
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
//    var styleData: [HomeImageData] = []
//    let styleRelay = BehaviorRelay(value: [HomeCreatorSectionModel]())
//    let dataSource: RxCollectionViewSectionedReloadDataSource<HomeCreatorSectionModel> = {
//       let ds = RxCollectionViewSectionedReloadDataSource<HomeCreatorSectionModel>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
//           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMainCell.identifier, for: indexPath) as? HomeMainCell else { return UICollectionViewCell() }
//           cell.bind(item, false)
//           return cell
//       })
//        return ds
//    }()
//    
//    func transform(input: Input) -> Output {
//        let viewWillAppear = input.viewWillAppear
//            .do(onNext: { _ in
//                self.currentPage = 0
//                self.styleData.removeAll()
//                self.readBookmarkCody(page: self.currentPage, size: 20)
//            }).map{ _ in }
//        
//        let pageDriver = page
//            .do(onNext: { data in
//                self.readBookmarkCody(page: self.currentPage, size: 20)
//            }).map{ _ in }.asDriver(onErrorJustReturn: ())
//        
//        let stylePagination = input.stylePagination
//            .do { row in
//                guard row == self.styleData.count - 1 else { return }
//                if self.isLastPage == false {
//                    self.currentPage += 1
//                    self.page.onNext(self.currentPage)
//                }
//            }.map{ _ in }.asDriver()
//        
//        let styleModelSelected = input.styleModelSelected
//            .do { model in
//                guard let navi = UIApplication.shared.visibleViewController?.navigationController else { return }
//                let sb = UIStoryboard(name: "Home", bundle: nil)
//                let scene = sb.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
//                scene.viewModel = HomeDetailViewModel(id: model.id, title: "")
//                navi.pushViewController(scene, animated: true)
//            }.map{ _ in }.asDriver()
//        
//        input.refreshLoading
//            .drive(onNext: { data in
//                self.currentPage = 0
//                self.styleData.removeAll()
//                self.refreshLoading.accept(true)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.readBookmarkCody(page: self.currentPage, size: 20)
//                }
//            }).disposed(by: bag)
//        return Output(viewWillAppear: viewWillAppear,
//                      pageChanged: pageDriver,
//                      stylePagination: stylePagination,
//                      styleModelSelected: styleModelSelected,
//                      refreshLoading: refreshLoading.asDriver(onErrorJustReturn: false))
//    }
//    
//    private func readBookmarkCody(page: Int, size: Int) {
//        apiManager.readBookmarkCody(page: page, size: size) { response in
//            switch response {
//            case .success(let data):
//                self.isLastPage = data.last
//                data.content.forEach{ self.styleData.append($0) }
//                self.styleRelay.accept([HomeCreatorSectionModel(model: 0, items: self.styleData)])
//                self.refreshLoading.accept(false)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    
//}
