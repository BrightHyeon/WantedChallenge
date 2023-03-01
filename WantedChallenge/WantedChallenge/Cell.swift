//
//  Cell.swift
//  WantedChallenge
//
//  Created by Hyeonsoo Kim on 2023/02/28.
//

import UIKit

final class Cell: UITableViewCell {
    private var urlString: String?
    
    // 스택뷰
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 이미지뷰
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 프로그레스
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.5
        return progressView
    }()
    
    // 이미지 로드 버튼
    private lazy var loadButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Load"
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
            self?.setImage()
        }))
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(from urlString: String) {
        self.urlString = urlString
    }
    
    func setImage() {
        photoView.image = UIImage(systemName: "photo")
        Task {
            do {
                guard let url = URL(string: urlString!) else { throw NetworkError.invalidStringForURL }
                try await photoView.fetchImage(from: url)
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        [photoView, progressView, loadButton].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            photoView.widthAnchor.constraint(equalToConstant: 150),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            
            loadButton.widthAnchor.constraint(equalToConstant: 80),
            loadButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}
