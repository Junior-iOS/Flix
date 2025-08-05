//
//  Cast.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation

struct Cast: Codable, Hashable {
    let person: Person
    let character: Character?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(person.id)
    }
    
    static func == (lhs: Cast, rhs: Cast) -> Bool {
        lhs.person.id == rhs.person.id
    }
}

struct Person: Codable {
    let id: Int
    let url: String
    let name: String
    let birthday: String?
    let deathday: String?
    let image: PosterImage?
}

struct Character: Codable {
    let id: Int
    let name: String
}
