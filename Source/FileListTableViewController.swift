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
    fileprivate lazy var dataSource: [File] = [
        File(endpoint: .file1MB, isDownloaded: false),
        File(endpoint: .file3MB, isDownloaded: false),
        File(endpoint: .file5MB, isDownloaded: false),
        File(endpoint: .file10MB, isDownloaded: false),
        File(endpoint: .file20MB, isDownloaded: false),
        File(endpoint: .file30MB, isDownloaded: false)
    ]
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

        cell.textLabel?.text = dataSource[indexPath.row].endpoint.description
        cell.detailTextLabel?.text = ""
        cell.accessoryType = dataSource[indexPath.row].isDownloaded ? .checkmark : .none

        return cell
    }
}

// MARK: - Table view delegate
extension FileListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let networkManager = NetworkManager(endpoint: dataSource[indexPath.row].endpoint)

        networkManager.download { url, response, error in
            DispatchQueue.main.async { [unowned self] in
                // Update the data source's state
                self.dataSource[indexPath.row] = File(
                    endpoint: self.dataSource[indexPath.row].endpoint, isDownloaded: true
                )
                
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
}
