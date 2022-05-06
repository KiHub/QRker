//
//  ListViewController.swift
//  QRker
//
//  Created by  Mr.Ki on 04.05.2022.
//

import UIKit

class ListViewController: UIViewController {

    let cellId = "cell"
    var tableView = UITableView()
    var savedNewsToDisplay = [QrList]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("loaded"), object: nil, queue: nil) { _ in
            self.downloadNewsFromList()
        }
    }

    func setup() {
        downloadNewsFromList()
        setupTableView()
        setupRefreshControl()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: appMainColor]
    }

    private func setupTableView() {
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = appBackGroundColor
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
