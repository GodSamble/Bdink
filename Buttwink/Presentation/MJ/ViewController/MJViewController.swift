//
//  MJViewController.swift
//  Buttwink
//
//  Created by 이명진 on 12/23/24.
//

import UIKit

final class MJViewController: UIViewController {
    
    // MARK: - UIComponents
    
    let mockData: [BoxOffice] = [
        BoxOffice(rank: "1", movieName: "Avatar: The Way of Water", openDate: "2023-12-16", audienceCount: "20345"),
        BoxOffice(rank: "2", movieName: "The Marvels", openDate: "2023-11-10", audienceCount: "18230"),
        BoxOffice(rank: "3", movieName: "Frozen 3", openDate: "2023-11-22", audienceCount: "16500"),
        BoxOffice(rank: "4", movieName: "Oppenheimer", openDate: "2023-07-21", audienceCount: "15200"),
        BoxOffice(rank: "5", movieName: "Spider-Man: Across the Spider-Verse", openDate: "2023-06-02", audienceCount: "14100"),
        BoxOffice(rank: "6", movieName: "Dune: Part Two", openDate: "2023-11-03", audienceCount: "12780"),
        BoxOffice(rank: "7", movieName: "Elemental", openDate: "2023-06-16", audienceCount: "11450"),
        BoxOffice(rank: "8", movieName: "The Batman: Part II", openDate: "2025-03-04", audienceCount: "10200")
    ]
    
    private let rootView = MJView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
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
    
}

extension MJViewController: UICollectionViewDelegate {
    
}


extension MJViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MJCell.className, for: indexPath) as? MJCell else { fatalError() }
        
        
        cell.bind(model: mockData[indexPath.row])
        
        return cell
        
    }
    
    
}
