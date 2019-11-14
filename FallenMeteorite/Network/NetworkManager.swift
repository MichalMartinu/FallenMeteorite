//
//  NetworkManager.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

final class NetworkManager {

    enum Result {
        case success([Meteorite])
        case offline
        case error(String)
    }

    var urlRequest: URL? {
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

    private let scheme = "https"
    private let host = "data.nasa.gov"
    private let path = "/resource/gh4g-9sfh.json"
    private let appToken = "3STavZkgZFubnTHrKZQg9ITmo"
    private let sqlQueryString = "year >= '2011-01-01T00:00' and mass IS NOT NULL"
    private let orderString = "mass DESC"

    private let offlineErrorCode = -1009

    func loadData(completion: @escaping (Result) -> Void) {

        guard let urlRequest = urlRequest else {
            return completion(.error("Invalid URL, we can't update your feed :("))
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            if let error = error {

                if let nsError = error as NSError?, nsError.code == self.offlineErrorCode {
                    return completion(.offline)
                }

                return completion(.error("\(error.localizedDescription)"))
            }

            guard let data = data else {
                return completion(.error("There are no data to show."))
            }

            do {
                let meteorites = try JSONDecoder().decode([Meteorite].self, from: data)
                return completion(.success(meteorites))
            } catch let error {
                return completion(.error(error.localizedDescription))
            }
        }.resume()
    }
}
