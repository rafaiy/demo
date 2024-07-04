//
//  URLClass.swift
//  SwiftUIDemoApp
//
//  Created by Rafaiy Rehman on 13/06/24.
//

import Foundation

enum HttpMethod: String{
    case post = "POST"
    case get = "GET"
}

protocol APIDependency {
    var baseURL: String { get }
    var endPoint: String { get }
    var headers:[String: String] { get }
    var url: URL { get }
    var body: Encodable? { get }
    var httpMethod: HttpMethod { get }
}


enum ApisType {
    case cartoonListing
    case otherListing
}



extension ApisType : APIDependency {
    var body: (any Encodable)? {
        return nil
    }
    
    var endPoint: String {
        switch self {
        case .cartoonListing:
            return "cartoons/cartoons2D"
        case .otherListing:
            return "cartoons/cartoons2D"

        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .cartoonListing:
            return .get
        case .otherListing:
            return .get
        }
    }
    
    var baseURL: String {
        switch self {
        case .cartoonListing:
            return "https://api.sampleapis.com/"
        case .otherListing:
            return "https://api.sampleapis.com/"
        }
    }
    
    var headers: [String : String] {
        return [
        "Content-Type": "application/json"
        ]
    }
    
    var url: URL {
        return URL(string: "\(baseURL)\(endPoint)")!
    }
        

}
