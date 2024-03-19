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

protocol APIServiceProtocol {
    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void)
}

class APIService: APIServiceProtocol {
    
    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void){
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=50") else {
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
