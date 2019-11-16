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

    private let offlineErrorCode = -1009

    func loadDataWith(_ urlRequest: URL?, completion: @escaping (Result) -> Void) {

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
