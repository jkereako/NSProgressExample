//
//  FileListTableViewController.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/18/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import UIKit

class FileListTableViewController: UITableViewController {
    fileprivate let cellIdentifier = "cell"
    fileprivate lazy var dataSource: [Endpoint] = [.file1MB, .file3MB, .file5MB, .file10MB,
                                                   .file20MB, .file30MB]
}

// MARK: - Table view data source
extension FileListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row].description
        cell.detailTextLabel?.text = ""
        cell.accessoryType = .none

        return cell
    }
}

// MARK: - Table view delegate
extension FileListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let networkManager = NetworkManager(endpoint: dataSource[indexPath.row])
        
        networkManager.download { url, response, error in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
        }
    }
}
