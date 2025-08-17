//
//  Bind.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import Foundation

class Bindable<T> {
    init(value: T) {
        self.value = value
    }

    var value: T {
        didSet {
            observers.forEach { observe in
                observe(value)
            }
        }
    }

    fileprivate var observers: [((T) -> Void)] = []

    func bind(observer: @escaping (T) -> Void) {
        self.observers.append(observer)
    }
}
