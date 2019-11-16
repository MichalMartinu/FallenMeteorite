//
//  UrlRequest.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 16/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

struct UrlRequest {
    
    static var request: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "$$app_token", value: appToken),
            URLQueryItem(name: "$where", value: sqlQueryString),
            URLQueryItem(name: "$order", value: orderString)
        ]
        return urlComponents.url
    }

    private static let scheme = "https"
    private static let host = "data.nasa.gov"
    private static let path = "/resource/gh4g-9sfh.json"
    private static let appToken = "3STavZkgZFubnTHrKZQg9ITmo"
    private static let sqlQueryString = "year >= '2011-01-01T00:00' and mass IS NOT NULL"
    private static let orderString = "mass DESC"
}
