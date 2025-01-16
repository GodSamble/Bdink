////
////  BookmarkMainVC.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BookmarkMainVM: CommonViewModelType {
//    
//    struct Input {
//        let searchTextFieldTapped: Driver<Void>
//        let notiButtonTapped: Driver<Void>
//    }
//    
//    struct Output {
//        let searchTextFieldTapped: Driver<Void>
//        let notiButtonTapped: Driver<Void>
//    }
//    
//    var bookmarkItemVC: BookmarkItemVC
//    var bookmarkCodyVC: BookmarkCodyVC
//    init() {
//        self.bookmarkItemVC = BookmarkItemVC()
//        bookmarkItemVC.bind(viewModel: BookmarkItemVM())
//        self.bookmarkCodyVC = BookmarkCodyVC()
//        bookmarkCodyVC.bind(viewModel: BookmarkCodyVM())
//    }
//    
//    func transform(input: Input) -> Output {
//        let searchTextFieldTapped = input.searchTextFieldTapped
////            .do(onNext: {
////                guard let navi = UIApplication.shared.visibleViewController?.navigationController else { return }
////                var scene = SearchPagerVC()
////                scene.bind(viewModel: SearchPagerVM())
////                navi.pushViewController(scene, animated: true)
////            }).asDriver()
//                
//        let notiButtonTapped = input.notiButtonTapped
////            .do(onNext: {
////                guard let navi = UIApplication.shared.visibleViewController?.navigationController else { return }
////                let sb = UIStoryboard(name: "Notification", bundle: nil)
////                guard let vc = sb.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC else { return }
////                UIApplication.shared.applicationIconBadgeNumber = 0
////                navi.pushViewController(vc, animated: true)
////            }).asDriver()
//        
//        return Output(searchTextFieldTapped: searchTextFieldTapped,
//                      notiButtonTapped: notiButtonTapped)
//    }
//    
//    
//    
//}
