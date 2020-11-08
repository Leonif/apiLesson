//
//  FriendsView.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 08.11.2020.
//

import UIKit

class FriendsView: UIView {
    
    private(set) var tableView = UITableView()
    
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
        setNeedsUpdateConstraints()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
}

