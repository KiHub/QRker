//
//  ListVCExtensions.swift
//  QRker
//
//  Created by  Mr.Ki on 06.05.2022.
//

import UIKit
import SafariServices

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        cell.selectionStyle = .none
        cell.backgroundColor = appBackGroundColor
        cell.textLabel?.textColor = appMainColor
        cell.detailTextLabel?.textColor = appSecondColor
        let savedUrls = savedNewsToDisplay[indexPath.row]
        cell.textLabel?.text = "◉\(savedUrls.url ?? "")"
        cell.textLabel?.numberOfLines = 0
     //   cell.detailTextLabel?.text = "◉\(String(newsViewData.points))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNewsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = savedNewsToDisplay[indexPath.row].url
       guard let url = URL(string: link ?? "https://google.com") else {return}
        let configuration = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.preferredControlTintColor = appMainColor
        safariViewController.preferredBarTintColor = appBackGroundColor
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .normal, title: "Delete") {  (contextualAction, view, boolValue) in
            print("delete")
            
            CoreDataManager.shared.deleteNewsFromDataBase(model: self.savedNewsToDisplay[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.savedNewsToDisplay.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
        item.image = UIImage(systemName: "trash")
        item.backgroundColor = converter.hexStringToUIColor(hex: "#95d5b2")
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
        return swipeActions
    }
    
}

extension ListViewController {
    func setNews(news: [QrList]) {
        DispatchQueue.main.async {
            self.savedNewsToDisplay = news
            self.tableView.reloadData()
        }
    }
    
    func setEmptyNews() {
        view.backgroundColor = .systemRed
    }
    
}

extension ListViewController {
    
    func downloadNewsFromList() {
        CoreDataManager.shared.fetchNewsFromDataBase { [weak self] result in
            switch result {
            case .success(let news):
                self?.savedNewsToDisplay = news
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        refreshControl.tintColor = converter.hexStringToUIColor(hex: "#c77dff")
        tableView.refreshControl = refreshControl
    }
    @objc func refreshContent() {
        tableView.reloadData()
        print("refresh")
        let dispatchTime = DispatchTime.now() + Double(0.5)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}

