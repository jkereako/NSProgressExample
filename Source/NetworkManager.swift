//
//  NetworkManager.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/18/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation

struct NetworkManager {
    let endpoint: Router
    
    /// Downloads a file and stores it locally
    func download() {
        let session = URLSession.shared
        let urlRequest = URLRequest(url: endpoint.url)
        let downloadTask = session.downloadTask(with: urlRequest) { url, response, error in
            print(url)
        }
        
        downloadTask.resume()
    }
}
