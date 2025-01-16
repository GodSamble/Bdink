////
////  BookmarkMainVM.swift
////  Buttwink
////
////  Created by 고영민 on 1/9/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BookmarkMainVC: UIViewController, ViewModelBindableType {
//    
//    var viewModel: BookmarkMainVM!
//    private let bag = DisposeBag()
//
//    // MARK: lazy var
//    // TextField in NavigationBar
//
//    // X버튼 in NavigationBar
//    lazy var noti: UIBarButtonItem = {
//        let button = UIBarButtonItem()
//        button.image = UIImage(named: "able.alertbell.on")
//        return button
//    }()
//    
//    private let segmentedControl: UISegmentedControl = {
//        let segmentedControl = UnderlineSegmentedControl(items: ["아이템", "코디"])
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        return segmentedControl
//      }()
//
//    var dataViewControllers: [UIViewController] {
//        [self.viewModel.bookmarkItemVC, self.viewModel.bookmarkCodyVC]
//      }
//    private let pageVC: UIPageViewController = {
//        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        return vc
//    }()
//    var currentPage: Int = 0 {
//        didSet {
//          /// from segmentedControl -> pageViewController 업데이트
//          let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
//          self.pageVC.setViewControllers(
//            [dataViewControllers[self.currentPage]],
//            direction: direction,
//            animated: true,
//            completion: nil
//          )
//        }
//      }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
////        ProductNavigationController.setSearchHashtagTextField(vc: self, searchTextField: searchTextField, doneButton: noti)
//        layout()
//        configure()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        alertBtnSetting()
//    }
//    
//    func bindViewModel() {
////        let searchTextFieldTapped = searchTextField.rx.editingDidBegin
////            .do(onNext: { _ in
////                self.searchTextField.endEditing(true)
////            })
////            .map{ _ in }
////            .asDriver(onErrorJustReturn: ())
////        let notiButtonTapped = noti.rx.tap.throttle(.milliseconds(300),latest: false, scheduler: MainScheduler.instance)
////            .asDriver(onErrorJustReturn: ())
//        
//        let input = BookmarkMainVM.Input(
////            searchTextFieldTapped: searchTextFieldTapped,
////            notiButtonTapped: notiButtonTapped)
//            )
//        
//        let output = viewModel.transform(input: input)
////        [output.searchTextFieldTapped.drive(),
////         output.notiButtonTapped.drive()
//        [
//        ].forEach{ $0.disposed(by: bag) }
//    }
//    
//    private func layout(){
//        self.view.addSubview(self.segmentedControl)
//        self.view.addSubview(self.pageVC.view)
//        NSLayoutConstraint.activate([
//          self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//          self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//          self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//          self.segmentedControl.heightAnchor.constraint(equalToConstant: 40),
//        ])
//        NSLayoutConstraint.activate([
//          self.pageVC.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//          self.pageVC.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//          self.pageVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//          self.pageVC.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor),
//        ])
//    }
//    
//    private func configure(){
//        // segmentControl + pageView
//        pageVC.setViewControllers([dataViewControllers[0]], direction: .forward, animated: true)
//        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
//        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.deep ?? .blue,
//                                                      .font: UIFont.getCustomFont(font: .CJKkr, weight: .Medium, size: 15)], for: .normal)
//            self.segmentedControl.setTitleTextAttributes(
//              [
//                NSAttributedString.Key.foregroundColor: UIColor.ableBlue ?? .blue,
//                .font: UIFont.getCustomFont(font: .CJKkr, weight: .Medium, size: 15)
//              ],
//              for: .selected
//            )
//        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
//        self.segmentedControl.selectedSegmentIndex = 0
//    }
//    
//    @objc private func changeValue(control: UISegmentedControl) {
//        // 코드로 값을 변경하면 해당 메소드 호출 x
//        self.currentPage = control.selectedSegmentIndex
//    }
//    
////    private func alertBtnSetting() {
////        if UIApplication.shared.applicationIconBadgeNumber == 0 {
////            noti.image = UIImage(named: "able.alertbell.on")
////        } else {
////            noti.image = UIImage(named: "able.alertbell.badge.on")
////        }
////    }
//    
//}
