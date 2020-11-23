//
//  FriendCell.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 23.11.2020.
//

import UIKit

final class FriendCell: UITableViewCell {
    
    private(set) var avatarFriendImage = AsyncImageView()
    private(set) var titleLabel = UILabel()
    
    static let id: String = "FriendCellId"
    
    private var photoService: PhotoService?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError()
    }
    
    func bind(friend: FriendInfoViewItem, photoService: PhotoService) {
        titleLabel.text = friend.name
        avatarFriendImage.image = UIImage(named: "astronaut")
        self.photoService = photoService
        
        loadPhotoPost(friend)
        
    }
    
    // MARK: - Override
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            avatarFriendImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarFriendImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarFriendImage.widthAnchor.constraint(equalToConstant: 40),
            avatarFriendImage.heightAnchor.constraint(equalToConstant: 40),
            avatarFriendImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: avatarFriendImage.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        super.updateConstraints()
    }
    
    
    override func prepareForReuse() {
        avatarFriendImage.image = UIImage()
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
        avatarFriendImage.image = UIImage(named: "astronaut")
        avatarFriendImage.contentMode = .scaleAspectFit
        avatarFriendImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(avatarFriendImage)
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    private func loadPhotoPost(_ friend: FriendInfoViewItem) {
        photoService?.photo(url: friend.imageUrlString) { [weak self] (image) in
            self?.avatarFriendImage.image = image
        }
        
    }
}
