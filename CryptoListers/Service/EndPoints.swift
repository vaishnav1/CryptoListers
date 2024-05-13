//
//  EndPoints.swift
//  CryptoListers
//
//  Created by Vaishnav on 13/05/24.
//

import Foundation

enum EndPoints {
    case getData
    
    private var baseUrl: String {
        return "https://"
    }
    
    private var urlAddress: String {
        return ".api.mockbin.io/"
    }
    
    private var apikey: NSDictionary {
        if let keyFile = Bundle.main.path(forResource: "Key", ofType: "plist") {
            return NSDictionary(contentsOfFile: keyFile)!
        } else {
            fatalError(ErrorMessage.needsApiKey.rawValue)
        }
    }
}

extension EndPoints {
    var url: URL {
        switch self {
        case .getData:
            return URL(string: baseUrl + "\(apikey["apiKey"]!)" + urlAddress)!
        }
    }
}
