//
//  Serie.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation

final class TVShow: Codable, Hashable {
    let id: Int
    let name: String
    let genres: [String]
    let status: String
    let premiered: String?
    let ended: String?
    let schedule: Schedule
    let rating: Rating
    let image: PosterImage?
    let summary: String

    init(
        id: Int,
        name: String,
        genres: [String],
        status: String,
        premiered: String?,
        ended: String?,
        schedule: Schedule,
        rating: Rating,
        image: PosterImage?,
        summary: String
    ) {
        self.id = id
        self.name = name
        self.genres = genres
        self.status = status
        self.premiered = premiered
        self.ended = ended
        self.schedule = schedule
        self.rating = rating
        self.image = image
        self.summary = summary
    }

    var ratingValue: Double {
        rating.average ?? 0.0
    }

    var mediumPosterImage: String {
        image?.medium ?? ""
    }

    var originalPosterImage: String {
        image?.original ?? ""
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
        lhs.id == rhs.id
    }
}

class Schedule: Codable {
    let time: String
    let days: [String]
}

class Rating: Codable {
    let average: Double?
}

class PosterImage: Codable {
    let medium: String
    let original: String
}
