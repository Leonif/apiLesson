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
    private var height: CGFloat = 40
    private var width: CGFloat = 40
    
    private var maxWidth: Double = 200
    
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
        
        if let h = item.height, let w = item.width {
            
            let originalRatio = Double(w) / Double(h)
            let w1 = maxWidth
            let h1 = maxWidth / originalRatio
            
            
            height = CGFloat(h1)
            width = CGFloat(w1)
            setNeedsUpdateConstraints()
        }
        loadPhotoPost(item)
    }
    
    // MARK: - Override
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImage.widthAnchor.constraint(equalToConstant: width),
            postImage.heightAnchor.constraint(equalToConstant: height),
        ])
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        super.updateConstraints()
    }
    
    
    override func prepareForReuse() {
        postImage.image = UIImage()
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
        postImage.contentMode = .scaleAspectFit
        postImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postImage)
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)
    }
    
    private func loadPhotoPost(_ item: ResponseItem) {
        if let string = item.photoUrl {
            photoService.photo(url: string) { [weak self] (image) in
                self?.postImage.image = image
            }
        }
    }
}
