//
//  CastDetailsViewModel.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit

protocol CastDetailsViewModelProtocol {
    var cast: Cast { get }
}

final class CastDetailsViewModel: CastDetailsViewModelProtocol {
    let cast: Cast
    
    init(cast: Cast) {
        self.cast = cast
    }
}
