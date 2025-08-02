//
//  Sercie.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation
import RxSwift

protocol ServiceProtocol {
    func getShows(page: Int) -> Single<[TVShow]>
}

enum ServiceError: Error {
    case invalidData
    case networkError(Error)
}

final class Service: ServiceProtocol {
    
    // MARK: - Methods
    func getShows(page: Int) -> Single<[TVShow]> {
        Single.create { single in
            Task {
                do {
                    let shows = try await self.getShowsAsync(page: page)
                    single(.success(shows))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Private Methods
    private func getShowsAsync(page: Int) async throws -> [TVShow] {
        try await fetch(endpoint: .pagedShows(page: page), decodingType: [TVShow].self)
    }
    
    private func fetch<T: Decodable>(endpoint: TVMazeEndpoint, decodingType: T.Type) async throws -> T {
        guard let request = endpoint.asURLRequest() else {
            throw ServiceError.invalidData
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(decodingType, from: data)
        } catch let error as DecodingError {
            throw ServiceError.networkError(error)
        }
    }
}

