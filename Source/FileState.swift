//
//  FileState.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/20/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation

enum FileState {
    case empty
    case downloading
    case saved
}

// MARK: - CustomStringConvertible
extension FileState: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return "Empty"
            
        case .downloading:
            return "Downloading"
            
        case .saved:
            return "Saved"
        }
    }
}
