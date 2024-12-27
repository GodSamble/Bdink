//
//  MovieViewController.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class MovieViewController: UIViewController {
    
    private let viewModel: MovieViewModelType
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .systemBackground
        $0.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
    }
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
        $0.color = .gray
    }
    
    private let refreshControl = UIRefreshControl().then {
        $0.tintColor = .gray
    }
    
    convenience init() {
        let networkService = DefaultBoxOfficeNetworkService()
        let boxOfficeMapper = DefaultBoxOfficeMapper()
        let movieRepository = DefaultMovieRepository(
            networkService: networkService,
            mapper: boxOfficeMapper
        )
        let fetchMoviesUseCase = DefaultFetchMoviesUseCase(
            movieRepository: movieRepository
        )
        let presentationMapper = DefaultMoviePresentationMapper()
        
        let viewModel = MovieViewModel(
            fetchMoviesUseCase: fetchMoviesUseCase,
            moviePresentationMapper: presentationMapper
        )
        
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: MovieViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        bindViewModel()
        
        viewModel.inputs.fetchTrigger.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "박스오피스"
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.fetchTrigger)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.outputs.movies
            .bind(to: collectionView.rx.items(
                cellIdentifier: MovieCell.identifier,
                cellType: MovieCell.self
            )) { _, movie, cell in
                cell.configure(with: movie)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .filter { !$0 }
            .bind { [weak self] _ in
                self?.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.error
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.handleItemSelection(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Actions
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "오류",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func handleItemSelection(at indexPath: IndexPath) {
        print("Selected item at index: \(indexPath.row)")
    }
}

// MARK: - Utilities
extension String {
    var formattedWithCommas: String {
        guard let number = Int(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? self
    }
}
