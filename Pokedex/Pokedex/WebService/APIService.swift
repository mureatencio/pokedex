//
//  APIService.swift
//  Pokedex
//

import Foundation

// MARK: - Network Errors
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

// MARK: - API Service Protocol definition

protocol APIServiceProtocol {
    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void)
    func getPokemonDetails(for url: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void)
}

// MARK: - API Service implementation

class APIService: APIServiceProtocol {
    // MARK: - Properties
    private let session: URLSessionProtocol
    private let pageSize = 50
    
    // MARK: - Init
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - API call to fetch Pokemon characters list
    
    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void){
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
    
    // MARK: - API call to fetch Pokemon details
    
    func getPokemonDetails(for url: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
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
                let pokemon = try decoder.decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
}
