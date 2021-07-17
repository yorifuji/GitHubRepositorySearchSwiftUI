//
//  GitHubAPI.swift
//  GitHubRepositorySearchSwiftUI
//
//  Created by yorifuji on 2021/06/07.
//

import Combine
import Foundation

enum Failure: Error {
    case createURLError
    case urlError(URLError)
    case responseError
    case statusError(Int)
    case decodeError(Error)
}

protocol GitHubAPIProtocol {
    static func searchRepository(_ query: String) -> AnyPublisher<SearchResponse, Failure>
}

enum SearchRepositoryClient: GitHubAPIProtocol {

    private static let baseURL = "https://api.github.com/search/repositories?q="

    private static let decorder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static func searchRepository(_ query: String) -> AnyPublisher<SearchResponse, Failure> {
        guard let url = URL(string: baseURL + query) else {
            return Fail(error: Failure.createURLError).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                Failure.urlError(error)
            }
            .tryMap { (data, response) -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw Failure.responseError
                }
                if (200..<300).contains(httpRes.statusCode) == false {
                    throw Failure.statusError(httpRes.statusCode)
                }
                return data
            }
            .decode(type: SearchResponse.self, decoder: decorder)
            .mapError { $0 as? Failure ?? .decodeError($0) }
            .eraseToAnyPublisher()
    }
}

protocol GitHubAPIProtocol2 {
    static func searchRepository(_ query: String) -> AnyPublisher<Result<SearchResponse, Failure>, Never>
}

enum GitHubAPI2: GitHubAPIProtocol2 {

    private static let baseURL = "https://api.github.com/search/repositories?q="

    private static func decoder() -> JSONDecoder {
        let decoder: JSONDecoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    static func searchRepository(_ query: String) -> AnyPublisher<Result<SearchResponse, Failure>, Never> {
        guard let url = URL(string: baseURL + query) else {
            return Just<Result<SearchResponse, Failure>>(.failure(.createURLError)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { Failure.urlError($0) }
            .map { $0.data }
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .map { Result<SearchResponse, Failure>.success($0)}
            .mapError { Failure.decodeError($0) }
            .catch { Just<Result<SearchResponse, Failure>>(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
