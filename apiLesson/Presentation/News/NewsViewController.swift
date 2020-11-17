//
//  NewsViewController.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

import UIKit
import PromiseKit

class NewsViewController: UIViewController {
    
    let rootView = NewsView()
    let servise = NewsFeedService()
    var news: [ResponseItem] = []
    let formatter = DateFormatter()
    
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
    
    private func setup() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.id)
    }
    
    override func viewDidLoad() {
        firstly {
            servise.getFeed()
        }.map { feed -> [ResponseItem] in
            feed.items.filter {
                switch $0.text {
                case .some:
                    return true
                default:
                    return false
                }
            }

        }.done { (items) in
            self.news = items
            self.rootView.tableView.reloadData()
        }.catch { (error) in
            debugPrint(error.localizedDescription)
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.id) as? NewsCell {
            let item = news[indexPath.row]
            cell.bind(item: item)
            return cell
        }
        
        fatalError()
    }
   
}
