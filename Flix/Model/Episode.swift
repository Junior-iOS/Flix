//
//  Episode.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation

struct Episode: Codable, Hashable {
    let id: Int
    let name: String
    let season: Int
    let number: Int?
    let airdate: String?
    let airtime: String?
    let airstamp: String?
    let runtime: Int?
    let rating: Rating
    let image: PosterImage?
    let summary: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }
} 
