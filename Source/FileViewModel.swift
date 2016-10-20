//
//  FileViewModel.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/19/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation

/// Data model
struct FileViewModel {
    let endpoint: Endpoint
    let state: FileState
    
    init(endpoint: Endpoint, state: FileState = .empty) {
        self.endpoint = endpoint
        self.state = state
    }
}
