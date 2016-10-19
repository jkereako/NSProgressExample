//
//  NetworkManager.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/18/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation

struct NetworkManager {
    let endpoint: Endpoint
    
    /// Downloads a file and stores it locally
    func download(completion: @escaping (URL?, URLResponse?, Error?) -> Void) {
        let session = URLSession.shared
        let urlRequest = URLRequest(url: endpoint.url)
        let downloadTask = session.downloadTask(with: urlRequest) { url, response, error in
            return completion(url, response, error)
        }
        
        downloadTask.resume()
    }
}
