//
//  CommentModalViewController.swift
//  Buttwink
//
//  Created by 고영민 on 2/17/25.
//

import UIKit
import SnapKit

final class CommentModalViewController: UIViewController {
    
    private lazy var commentsLabel : UILabel = {
        let label = UILabel()
        label.setText("아 이거 영상 재밌다", attributes: .init(style: .body, weight: .bold))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton()
        button.setTitle("뒤로가기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.addSubviews(commentsLabel, backButton)
        commentsLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(commentsLabel.snp.bottom).offset(12)
            make.centerY.equalToSuperview()
        }
    }
}

extension CommentModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 // Placeholder number of comments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "User \(indexPath.row + 1): This is a sample comment."
        return cell
    }
}
