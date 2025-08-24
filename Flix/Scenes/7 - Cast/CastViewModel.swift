//
//  CastViewModel.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import UIKit

protocol CastViewModelProtocol {
    func fetchCast()
    var castSubject: PublishSubject<[Cast]> { get }
    var errorSubject: PublishSubject<Error> { get }
    var cast: [Cast] { get set }
    var title: String { get }
    var show: TVShow { get }
}

final class CastViewModel: CastViewModelProtocol {
    
    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    var castSubject: PublishSubject<[Cast]> = PublishSubject<[Cast]>()
    let errorSubject = PublishSubject<Error>()
    var show: TVShow
    var cast: [Cast] = []
    
    var title: String {
        "Cast"
    }
    
    // MARK: - Init
    init(
        show: TVShow,
        service: ServiceProtocol = Service(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.show = show
        self.service = service
        self.networkMonitor = networkMonitor
    }
    
    func fetchCast() {
        guard networkMonitor.checkConnection() else {
            DispatchQueue.main.async { [weak self] in
                let noConnectionError = NSError(domain: "NoConnection", code: -1009, userInfo: [NSLocalizedDescriptionKey: "Sem conexão com a internet"])
                self?.errorSubject.onNext(ServiceError.networkError(noConnectionError))
            }
            return
        }
        
        service.getCast(showID: show.id)
            .subscribe(onSuccess: { [weak self] cast in
                self?.castSubject.onNext(cast)
            }, onFailure: { [weak self] _ in
                self?.handleFailure()
            })
            .disposed(by: disposeBag)
    }

    private func handleFailure() {
        errorSubject.onNext(ServiceError.invalidData)
    }
}
