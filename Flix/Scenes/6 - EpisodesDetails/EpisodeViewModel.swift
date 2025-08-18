//
//  DetailsEpisodeViewModel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import Foundation
import UIKit

protocol EpisodeDetailsViewModelProtocol {
    var episode: Episode { get }
    var title: String { get }
}

final class EpisodeViewModel: EpisodeDetailsViewModelProtocol {
    var episode: Episode

    init(episode: Episode) {
        self.episode = episode
    }

    var title: String {
        episode.name
    }
}
