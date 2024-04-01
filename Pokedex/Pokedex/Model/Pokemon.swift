//
//  Pokemon.swift
//  Pokedex
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let baseExperience: Int
    let height: Int
    let identifier: Int
    let name: String
    let sprites: Sprites
    let types: [PokemonType]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case identifier = "id"
        case height, name, sprites, types, weight
    }
}

// MARK: - Nested types

struct Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonType: Codable {
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
}
