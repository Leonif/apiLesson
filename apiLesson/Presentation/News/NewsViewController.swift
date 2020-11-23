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
    var nextId: String?
    var isLoading: Bool = false
    
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
        loadNews() {
            self.rootView.tableView.reloadData()
        }
        rootView.refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
    }
    
    
    private func loadNews(callback: (() -> Void)? = nil) {
        firstly {
            servise.getFeed()
        }.map { feed -> [ResponseItem] in
            self.mapNews(feed: feed)
        }.done { (items) in
            self.news = items
            callback?()
        }.catch { (error) in
            callback?()
            debugPrint(error.localizedDescription)
        }
    }
    
    private func mapNews(feed: Feed) -> [ResponseItem] {
        self.nextId = feed.nextFrom
        
        return feed.items.filter {
            switch $0.text {
            case .some:  return true
            default:     return false
            }
        }
    }
    
    
    @objc
    private func refreshFeed() {
        loadNews() {
            self.rootView.refreshControl.endRefreshing()
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
            if item.isOpen {
                debugPrint("")
            }
            cell.bind(item: item)
            
            cell.tap = { item in
                if let index = self.news.firstIndex(where: { $0.text == item.text  }) {
                    debugPrint(self.news[index],self.news[index].isOpen)
                    self.news[index].isOpen.toggle()
                    debugPrint(self.news[index],self.news[index].isOpen)
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    
                }
            }
            
            return cell
        }
        
        fatalError()
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoading else { return }
        
        if indexPath.row == news.count - 1 {
            let lastIndex = indexPath.row
            isLoading = true
            firstly {
                servise.getFeed(startFrom: nextId)
            }.done { (feed) in
                let newPageItems = self.mapNews(feed: feed)
                self.news.append(contentsOf: newPageItems)
                let indexPaths = self.makeIndexSet(lastIndex: lastIndex, newPageItems.count)
                tableView.insertRows(at: indexPaths, with: .automatic)
                self.isLoading = false
            }.catch { (error) in
                debugPrint(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    private func makeIndexSet(lastIndex: Int, _ newsCount: Int) -> [IndexPath] {
        let last = lastIndex + newsCount
        let indexPaths = Array(lastIndex + 1...last).map { IndexPath(row: $0, section: 0) }
        
        return indexPaths
    }
    
}


