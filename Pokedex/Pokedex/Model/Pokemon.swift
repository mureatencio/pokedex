//
//  Pokemon.swift
//  Pokedex
//

import Foundation

struct Pokemon: Codable {
    let baseExperience: Int
    let cries: Cries
    let height: Int
    let identifier: Int
    let name: String
    let sprites: Sprites
    let types: [PokemonType]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case identifier = "id"
        case cries, height, name, sprites, types, weight
    }
}

struct Cries: Codable {
    let latest: String
}

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
