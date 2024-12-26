//
//  MJViewController.swift
//  Buttwink
//
//  Created by 이명진 on 12/23/24.
//

import UIKit
import RxSwift

final class MJViewController: UIViewController {
    
    private let viewModel: MJViewModel
    private let disposeBag = DisposeBag()
    
    private var movieData: [BoxOffice] = [] // ViewModel 데이터를 저장할 변수
    private let rootView = MJView()
    
    // MARK: - Initializer
    
    init(viewModel: MJViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
        bindViewModel()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func setRegister() {
        rootView.collectionView.register(MJCell.self, forCellWithReuseIdentifier: MJCell.className)
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        Task {
            let input = MJViewModel.Input(viewDidLoad: ())
            let output = await viewModel.transform(input: input, disposeBag: disposeBag)
            
            await MainActor.run {
                self.movieData = output.movieData
                self.rootView.collectionView.reloadData()
            }
        }
    }
}

extension MJViewController: UICollectionViewDelegate {}

extension MJViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MJCell.className, for: indexPath) as? MJCell else { fatalError() }
        
        cell.bind(model: movieData[indexPath.row]) // ViewModel 데이터를 셀에 바인딩
        return cell
    }
}
