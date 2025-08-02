//
//  TVMazeEndpoint.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }

    func asURLRequest() -> URLRequest?
}

enum TVMazeEndpoint: Endpoint {
    case shows
    case pagedShows(page: Int)
    case show(id: Int)
    case cast(showID: Int)
    case seasons(showID: Int)
    case episodes(showID: Int)

    var baseURL: String { "https://api.tvmaze.com" }

    var path: String {
        switch self {
        case .shows, .pagedShows:
            return "/shows"
        case .show(let id):
            return "/shows/\(id)"
        case .cast(let showID):
            return "/shows/\(showID)/cast"
        case .seasons(let showID):
            return "/shows/\(showID)/seasons"
        case .episodes(let showID):
            return "/shows/\(showID)/episodes"
        }
    }

    var method: HTTPMethod { .GET }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .pagedShows(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        default:
            return nil
        }
    }

    var body: Data? { nil }

    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems

        guard let url = components?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body

        return request
    }
}

