//
//  UIViewController+Extensions.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import Foundation
import UIKit

public extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true)
    }
}
