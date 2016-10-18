//
//  Router.swift
//  NSProgressExample
//
//  Created by Jeff Kereakoglow on 10/18/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation

/// Provides type-safe URL buidling. Usage: `Router.file1MB.url`
enum Router {
    static let baseURLString = "https://github.com/jkereako/NSProgressExample/blob/master/Fixtures/"
    
    case file1MB
    case file3MB
    case file5MB
    case file10MB
    case file20MB
    case file30MB
    
    var url: URL {
        let path: String = {
            switch self {
            case .file1MB:
                return "1mb_test_file"
                
            case .file3MB:
                return "3mb_test_file"
                
            case .file5MB:
                return "5mb_test_file"
                
            case .file10MB:
                return "10mb_test_file"
                
            case .file20MB:
                return "20mb_test_file"
                
            case .file30MB:
                return "30mb_test_file"
            }
        }()
        
        var components = URLComponents(string: Router.baseURLString)!
        components.queryItems = [URLQueryItem(name: "raw", value: "true")]
        let baseURL = components.url!
        
        return baseURL.appendingPathComponent(path)
    }
}
