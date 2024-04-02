//
//  PokemonTypeEmojiConverter.swift
//  Pokedex
//

import Foundation

class PokemonTypeEmojiConverter {
    // Dictionary to map type names to emojis
    private static let typeEmojiMapping: [String: String] = [
        "normal": "🐾",
        "fire": "🔥",
        "water": "💧",
        "electric": "⚡",
        "grass": "🍃",
        "ice": "❄️",
        "fighting": "🥊",
        "poison": "☠️",
        "ground": "🌎",
        "flying": "🕊️",
        "psychic": "🔮",
        "bug": "🐞",
        "rock": "🪨",
        "ghost": "👻",
        "dragon": "🐉",
        "dark": "🌑",
        "steel": "🛡️",
        "fairy": "🧚",
        "stellar": "🌟"
    ]

    // Static method to map types from pokemon type to emoji
    static func emojis(for typesArray: [PokemonType]) -> String {
        let emojis = typesArray.compactMap { typeEmojiMapping[$0.type.name.lowercased()] }
        return emojis.joined(separator: " ")
    }
}
