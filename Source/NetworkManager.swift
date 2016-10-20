//
//  NetworkManager.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/18/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation

class NetworkManager: NSObject, ProgressReporting {
    fileprivate let endpoint: Endpoint
    fileprivate let completion: (URL) -> Void
    var progress: Progress

    init(endpoint: Endpoint, completion: @escaping (URL) -> Void) {
        self.endpoint = endpoint
        self.completion = completion
        progress = Progress()

        super.init()
    }
    
    /// Downloads a file and stores it locally
    func download() {
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil
        )

        let urlRequest = URLRequest(url: endpoint.url)
        
        let downloadTask = session.downloadTask(with: urlRequest)
        
        downloadTask.resume()
    }
}

// MARK: - URLSessionDownloadDelegate
extension NetworkManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {

        completion(location)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

        progress.totalUnitCount = expectedTotalBytes
        progress.completedUnitCount = fileOffset
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        progress.totalUnitCount = totalBytesExpectedToWrite
        progress.completedUnitCount = totalBytesWritten
    }
}
