//
//  NetworkError.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case noConnection
    case timeout
    case serverError
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "Sem conexão com a internet"

        case .timeout:
            return "Tempo limite excedido"

        case .serverError:
            return "Erro no servidor"

        case .invalidResponse:
            return "Resposta inválida do servidor"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noConnection:
            return "Verifique sua conexão com a internet e tente novamente"

        case .timeout:
            return "A conexão demorou muito. Tente novamente"

        case .serverError:
            return "O servidor está temporariamente indisponível. Tente mais tarde"

        case .invalidResponse:
            return "Houve um problema com a resposta do servidor. Tente novamente"
        }
    }
}
