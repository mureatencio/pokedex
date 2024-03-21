//
//  MockAPIService.swift
//  Pokedex
//

import Foundation

class MockAPIService: APIServiceProtocol {
    var getPokemonCharactersResult: Result<PokemonServiceResponse, NetworkError>?
    var getPokemonDetailsResult: Result<Pokemon, NetworkError>?

    func getPokemonCharacters(offset: Int, completion: @escaping (Result<PokemonServiceResponse, NetworkError>) -> Void) {
        if let result = getPokemonCharactersResult {
            completion(result)
        }
    }

    func getPokemonDetails(for url: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        if let result = getPokemonDetailsResult {
            completion(result)
        }
    }
}
