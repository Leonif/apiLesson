//
//  NewsCell.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    private(set) var postImage = UIImageView()
    private(set) var titleLabel = UILabel()
    
    static let id: String = "NewsCellId"
    
    private let photoService = PhotoService()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError()
    }
    
    func bind(item: ResponseItem) {
        titleLabel.text = item.text
        loadPhotoPost(item)
    }
    
    // MARK: - Override
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImage.widthAnchor.constraint(equalToConstant: 40),
            postImage.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        super.updateConstraints()
    }
    
    // MARK: - Private
    private func setup() {
        setupSelf()
        setupImage()
        setupTitleLabel()
        setNeedsUpdateConstraints()
    }
    
    private func setupSelf() {
        backgroundColor = .white
    }
    
    private func setupImage() {
        postImage.image = UIImage(named: "astronaut")
        postImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postImage)
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    private func loadPhotoPost(_ item: ResponseItem) {
        if let string = item.photoUrl {
            photoService.photo(url: string) { [unowned self] (image) in
                postImage.image = image
            }
        }
    }
}
