//
//  CastDetailsViewModel.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit

protocol CastDetailsViewModelProtocol {
    var nameText: String { get}
    var birthdayText: String { get }
    var deathdayText: String? { get }
    var ageText: String { get }
    var coverImageURL: URL? { get }
    var showStar: Bool { get }
    var shouldApplyGrayScale: Bool { get }
    var urlString: String { get }
}

final class CastDetailsViewModel: CastDetailsViewModelProtocol {
    // MARK: - Properties
    let nameText: String
    let birthdayText: String
    let deathdayText: String?
    let ageText: String
    let coverImageURL: URL?
    let showStar: Bool
    let shouldApplyGrayScale: Bool
    let urlString: String

    // MARK: - Init
    init(person: Person) {
        self.nameText = person.name
        self.birthdayText = CastDetailsViewModel.formatDate(text: "Birthday:", person.birthday)
        self.urlString = person.url

        if let deathday = person.deathday {
            self.deathdayText = CastDetailsViewModel.formatDate(text: "Deathday:", deathday)
        } else {
            self.deathdayText = nil
        }

        if let birthday = person.birthday {
            let age = CastDetailsViewModel.calculateAge(from: birthday, to: person.deathday)
            self.ageText = "Age: \(age ?? 0)"
        } else {
            self.ageText = "Age: -"
        }

        if let urlString = person.image?.original, let url = URL(string: urlString) {
            self.coverImageURL = url
        } else {
            self.coverImageURL = nil
        }

        self.showStar = person.deathday != nil
        self.shouldApplyGrayScale = person.deathday != nil
    }
    
    // MARK: - Private Methods
    private static func formatDate(text: String, _ dateString: String?) -> String {
        guard let dateString = dateString, !dateString.isEmpty else {
            return "\(text) Unknown"
        }
        let formatterGet = DateFormatter()
        formatterGet.dateFormat = "yyyy-MM-dd"
        if let date = formatterGet.date(from: dateString) {
            let formatterPrint = DateFormatter()
            formatterPrint.dateStyle = .medium
            return "\(text) \(formatterPrint.string(from: date))"
        } else {
            return "\(text) Unknown"
        }
    }
    
    private static func calculateAge(from birthday: String, to deathDay: String? = nil) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let birthDate = formatter.date(from: birthday) else {
            return nil
        }
        let endDate: Date
        if let deathDay = deathDay, let deathDate = formatter.date(from: deathDay) {
            endDate = deathDate
        } else {
            endDate = Date()
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthDate, to: endDate)
        return components.year
    }
}
