//
//  Season.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation

struct Season: Codable, Hashable {
    let id: Int
    let url: String
    let number: Int
    let name: String
    let episodeOrder: Int?
    let premiereDate: String?
    let endDate: String?
    let network: Network?
    let webChannel: WebChannel?
    let image: PosterImage?
    let summary: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Season, rhs: Season) -> Bool {
        lhs.id == rhs.id
    }
}

struct Network: Codable {
    let id: Int
    let name: String
}

struct WebChannel: Codable {
    let id: Int
    let name: String
} 
