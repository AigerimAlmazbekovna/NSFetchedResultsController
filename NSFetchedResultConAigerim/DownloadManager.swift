//
//  DownloadManager.swift
//  NSFetchedResultConAigerim
//
//  Created by Айгерим on 20.10.2024.
//

import Foundation
struct JokeCodable: Codable {
    let id: String
    let value: String
}
enum NetworkError: Error {
    case noData
    case noInternet
    case parsingError
}
final class DownloadManager {
    static let shared = DownloadManager()
    func downloadJoke(comletion: @escaping(Result<JokeCodable, NetworkError>) -> Void) {
        let url = URL(string: "https://api.chucknorris.io/jokes/random")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                comletion(.failure(.noInternet))
                return
            }
            guard let data else {
                comletion(.failure(.noData))
                return
            }
            do {
                let answer = try JSONDecoder().decode(JokeCodable.self, from: data)
                comletion(.success(answer))
            } catch {
                comletion(.failure(.parsingError))
            }
        }.resume()
    }
}
