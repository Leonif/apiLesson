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
    var friendList: [FriendInfo] = []
    
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
        
        service.getFirendInfo { [unowned self] (result) in
            switch result {
            case let .success(list):
                friendList = list
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
        
        cell.textLabel?.text = friend.firstName
        cell.imageView?.image = UIImage(named: "astronaut")
        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: URL(string: friend.photo50)!)
            
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        return cell
    }
}
