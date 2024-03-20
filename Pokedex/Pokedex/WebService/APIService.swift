//
//  APIService.swift
//  Pokedex
//

import Foundation


enum NetworkError: Error {
    case badUrl
    case invalidData
    case decodingError
}

extension NetworkError {
    var errorMessage: String {
        switch self {
        case .badUrl:
            return NSLocalizedString("Error_BadUrl", comment: "Invalid URL error")
        case .invalidData:
            return NSLocalizedString("Error_InvalidData", comment: "Invalid data error")
        case .decodingError:
            return NSLocalizedString("Error_DecodingError", comment: "Decoding error")
        }
    }
}

protocol APIServiceProtocol {
    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void)
}

class APIService: APIServiceProtocol {
    
    private let pageSize = 50
    
    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void){
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=\(pageSize)") else {
            completion(.failure(.badUrl))
            return
        }
    
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let pokemonResponse = try decoder.decode(PokemonServiceResponse.self, from: data)
                completion(.success(pokemonResponse))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
}
