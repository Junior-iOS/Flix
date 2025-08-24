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
    func getShow(id: Int) -> Single<TVShow>
    func getCast(showID: Int) -> Single<[Cast]>
    func getSeasons(showID: Int) -> Single<[Season]>
    func getEpisodes(showID: Int) -> Single<[Episode]>
}

enum ServiceError: Error, LocalizedError {
    case invalidData
    case networkError(Error)
    case invalidURL
    case httpError(Int)
    case decodingError(DecodingError)

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid Data"

        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"

        case .invalidURL:
            return "Invalid URL"

        case .httpError(let code):
            return "HTTP Error: \(code)"

        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        }
    }
}

final class Service: ServiceProtocol {
    // MARK: - Properties
    private let session: URLSession
    private let cache = NSCache<NSString, NSData>()

    // MARK: - Initialization
    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Methods

    func getShows(page: Int) -> Single<[TVShow]> {
        request(.pagedShows(page: page))
    }

    func getShow(id: Int) -> Single<TVShow> {
        request(.show(id: id))
    }

    func getCast(showID: Int) -> Single<[Cast]> {
        request(.cast(showID: showID))
    }

    func getSeasons(showID: Int) -> Single<[Season]> {
        request(.seasons(showID: showID))
    }

    func getEpisodes(showID: Int) -> Single<[Episode]> {
        request(.episodes(showID: showID))
    }

    // MARK: - Private Methods

    private func request<T: Decodable>(_ endpoint: TVMazeEndpoint) -> Single<T> {
        Single.create { single in
            Task {
                do {
                    let result: T = try await self.fetch(endpoint: endpoint)
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    private func fetch<T: Decodable>(endpoint: TVMazeEndpoint) async throws -> T {
        guard let request = endpoint.asURLRequest() else {
            throw ServiceError.invalidURL
        }

        // Verifica cache primeiro
        let cacheKey = NSString(string: request.url?.absoluteString ?? "")
        if let cachedData = cache.object(forKey: cacheKey) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: cachedData as Data)
            } catch {
                // Se falhar ao decodificar cache, continua com request
                print("⚠️ Cache decode failed, proceeding with network request")
            }
        }

        do {
            let (data, response) = try await session.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw ServiceError.httpError(httpResponse.statusCode)
                }
            }

            // Salva no cache
            cache.setObject(data as NSData, forKey: cacheKey)

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            print("❌ Decoding Error: \(error)")
            throw ServiceError.decodingError(error)
        } catch {
            print("❌ Network Error: \(error)")
            throw ServiceError.networkError(error)
        }
    }

    // MARK: - Cache Management

    func clearCache() {
        cache.removeAllObjects()
    }

    func removeCache(for endpoint: TVMazeEndpoint) {
        guard let request = endpoint.asURLRequest(),
              let urlString = request.url?.absoluteString else { return }
        cache.removeObject(forKey: NSString(string: urlString))
    }
}
