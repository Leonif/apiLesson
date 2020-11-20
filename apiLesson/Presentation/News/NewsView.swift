//
//  NewsView.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

import UIKit

class NewsView: UIView {
    private(set) var tableView = UITableView()
    private(set) var refreshControl = UIRefreshControl()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        ])
        
        
        super.updateConstraints()
    }
    
    
    private func setup() {
        backgroundColor = .red
        setupTableView()
        setupRefreshControl()
        setNeedsUpdateConstraints()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1.0
        addSubview(tableView)
    }
    
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        tableView.refreshControl = refreshControl
    }
}

