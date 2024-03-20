//
//  PokemonServiceResponse.swift
//  Pokedex
//

import Foundation

class PokemonServiceResponse: Codable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [PokemonListItem]
}
