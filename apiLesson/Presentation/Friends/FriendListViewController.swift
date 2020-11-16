//
//  FriendListViewController.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 28.09.2020.
//

import UIKit

final class FriendListViewController: UIViewController {
    
    let rootView = FriendsView()
    let service = FriendsService()
    let photoService = PhotoService()
    var friendList: [FriendInfoViewItem] = []
    
    
//    var notLoadedImages: [String: IndexPath] = [:]
    
    init() {
        super.init(nibName: .none, bundle: .none)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        photoService.urlLoaded = { [unowned self] url in
//            if let indexPath = notLoadedImages[url] {
//                rootView.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//        }
        
        service.getFirendInfo()
            .map { (friendInfoList) in
                friendInfoList.map { friend in
                    FriendInfoViewItem(name: friend.firstName, imageUrlString: friend.photo50)
                }
            }
            .add { [unowned self] (result) in
                switch result {
                case let .success(items):
                    friendList = items
                    rootView.tableView.reloadData()
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            }
    }
    
    private func setup() {
        rootView.tableView.dataSource = self
        rootView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}


extension FriendListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let friend = friendList[indexPath.row]
        
        cell.textLabel?.text = friend.name
        cell.imageView?.image = UIImage(named: "astronaut")
        
        photoService.photo(url: friend.imageUrlString) { image in
            cell.imageView?.image = image
//            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        
        
        return cell
    }
}


struct FriendInfoViewItem {
    let name: String
    let imageUrlString: String
}
