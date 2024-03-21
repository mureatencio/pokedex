//
//  PokemonServiceResponse.swift
//  Pokedex
//

import Foundation

// MARK: - PokemonServiceResponse

struct PokemonServiceResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]

    init(count: Int, next: String?, previous: String?, results: [PokemonListItem]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
