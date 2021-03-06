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
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate lazy var dataSource: [FileViewModel] = [
        FileViewModel(endpoint: .file1MB),
        FileViewModel(endpoint: .file3MB),
        FileViewModel(endpoint: .file5MB),
        FileViewModel(endpoint: .file10MB),
        FileViewModel(endpoint: .file20MB),
        FileViewModel(endpoint: .file30MB)
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
        let viewModel = dataSource[indexPath.row]
        
        cell.textLabel?.text = viewModel.endpoint.description
        cell.detailTextLabel?.text = viewModel.detail
        cell.accessoryType = viewModel.state == .saved ? .checkmark : .none
        
        return cell
    }
}

// MARK: - Table view delegate
extension FileListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Commence downloading if the file isn't already saved.
        guard self.dataSource[indexPath.row].state == .empty else {
            return
        }
        
        selectedIndexPath = indexPath
        
        networkManager = NetworkManager(endpoint: dataSource[indexPath.row].endpoint) { url in
            OperationQueue.main.addOperation { [unowned self] in
                
                // REVIEW: This crashes when tapping on multiple rows too quickly
                self.networkManager?.progress.removeObserver(
                    self, forKeyPath:
                    self.observedKeyPath,
                    context: &FileListTableViewControllerObservationContext
                )
                
                self.dataSource[indexPath.row] = FileViewModel(
                    endpoint: self.dataSource[indexPath.row].endpoint,
                    detail: FileState.saved.description,
                    state: .saved
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
        
        self.dataSource[indexPath.row] = FileViewModel(
            endpoint: self.dataSource[indexPath.row].endpoint, state: .downloading
        )
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
        
        // Update the UI
        OperationQueue.main.addOperation { [unowned self] in
            guard let indexPath = self.selectedIndexPath else {
                assertionFailure("`selectedIndexPath` is nil")
                return
            }
            
            let viewModel = self.dataSource[indexPath.row]
            self.dataSource[indexPath.row] = FileViewModel(
                endpoint: viewModel.endpoint,
                detail: progress.localizedAdditionalDescription,
                state: .downloading
            )
            
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
        }
    }
}
