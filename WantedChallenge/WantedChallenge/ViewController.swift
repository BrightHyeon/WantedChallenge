//
//  ViewController.swift
//  WantedChallenge
//
//  Created by Hyeonsoo Kim on 2023/02/28.
//

import UIKit

final class ViewController: UIViewController {
    private let imageURLs = [
        "https://picsum.photos/id/237/440/300",
        "https://picsum.photos/id/230/400/320",
        "https://picsum.photos/id/220/470/300",
        "https://picsum.photos/id/200/340/310",
        "https://picsum.photos/id/257/400/300"
    ]
    
    // 테이블뷰
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none // 구분선 x
        tableView.allowsSelection = false // cell highlight x
        tableView.isScrollEnabled = false // scroll x
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // 전체 이미지 로드 버튼
    private lazy var loadAllButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Load All Images"
        let button = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.tableView.subviews.forEach { cell in
                guard let cell = cell as? Cell else { return }
                cell.setImage()
            }
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(loadAllButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 550)
        ])
        
        NSLayoutConstraint.activate([
            loadAllButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            loadAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loadAllButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell else { return UITableViewCell() }
        cell.configure(from: imageURLs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
