//
//  FileListTableViewController.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/18/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import UIKit

fileprivate var FileListTableViewControllerObservationContext = 0

class FileListTableViewController: UITableViewController {
    fileprivate var networkManager: NetworkManager?
    fileprivate let cellIdentifier = "cell"
    fileprivate let observedKeyPath = "fractionCompleted"
    fileprivate lazy var dataSource: [FileViewModel] = [
        FileViewModel(endpoint: .file1MB, isDownloaded: false),
        FileViewModel(endpoint: .file3MB, isDownloaded: false),
        FileViewModel(endpoint: .file5MB, isDownloaded: false),
        FileViewModel(endpoint: .file10MB, isDownloaded: false),
        FileViewModel(endpoint: .file20MB, isDownloaded: false),
        FileViewModel(endpoint: .file30MB, isDownloaded: false)
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

        networkManager = NetworkManager(endpoint: dataSource[indexPath.row].endpoint) { url in
            OperationQueue.main.addOperation { [unowned self] in
                self.networkManager?.progress.removeObserver(self, forKeyPath: self.observedKeyPath)

                self.dataSource[indexPath.row] = FileViewModel(
                    endpoint: self.dataSource[indexPath.row].endpoint, isDownloaded: true
                )

                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }

        networkManager?.progress.addObserver(
            self,
            forKeyPath: observedKeyPath,
            options: [],
            context: &FileListTableViewControllerObservationContext
        )

        networkManager?.download()
    }
}

// MARK: - KVO
extension FileListTableViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {

        guard context == &FileListTableViewControllerObservationContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        guard let progress = object as? Progress else {
            assertionFailure("Expected a Progress object")
            return
        }

        // TODO: Update UI
        OperationQueue.main.addOperation {
            print(progress.fractionCompleted)
        }
    }
}
