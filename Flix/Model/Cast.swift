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

    // gera um id único a partir do person
    var id: Int { person.id }
}

struct Person: Codable, Hashable {
    let id: Int
    let url: String
    let name: String
    let birthday: String?
    let deathday: String?
    let image: PosterImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let image: PosterImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
}
