//
//  PokemonTypeEmojiConverterTests.swift
//  Pokedex
//

import XCTest
@testable import Pokedex

class PokemonTypeEmojiConverterTests: XCTestCase {
    
    func testEmojiForSingleType() {
        // Testing single type conversion
        let singleType = [PokemonType(type: TypeDetail(name: "fire"))]
        let expectedEmoji = "🔥"
        XCTAssertEqual(PokemonTypeEmojiConverter.emojis(for: singleType), expectedEmoji, "The emoji for the fire type should be 🔥.")
    }
    
    func testEmojiForMultipleTypes() {
        // Testing multiple types conversion
        let multipleTypes = [PokemonType(type: TypeDetail(name: "water")), PokemonType(type: TypeDetail(name: "electric"))]
        let expectedEmoji = "💧 ⚡"
        XCTAssertEqual(PokemonTypeEmojiConverter.emojis(for: multipleTypes), expectedEmoji, "The emojis for water and electric types should be 💧 and ⚡.")
    }
    
    func testEmojiForUnsupportedType() {
        // Testing conversion for an unsupported type
        let unsupportedType = [PokemonType(type: TypeDetail(name: "unknown"))]
        let expectedEmoji = ""
        XCTAssertEqual(PokemonTypeEmojiConverter.emojis(for: unsupportedType), expectedEmoji, "There should be no emoji for unsupported types.")
    }
    
    func testEmojiForMixedSupportedAndUnsupportedTypes() {
        // Testing mix of supported and unsupported types
        let mixedTypes = [PokemonType(type: TypeDetail(name: "grass")), PokemonType(type: TypeDetail(name: "unknown"))]
        let expectedEmoji = "🍃"
        XCTAssertEqual(PokemonTypeEmojiConverter.emojis(for: mixedTypes), expectedEmoji, "The emoji for grass type should be 🍃 and unsupported types should be ignored.")
    }
    
    func testEmojiForNoTypes() {
        // Testing conversion when no types are provided
        let noTypes = [PokemonType]()
        let expectedEmoji = ""
        XCTAssertEqual(PokemonTypeEmojiConverter.emojis(for: noTypes), expectedEmoji, "There should be no emoji when no types are provided.")
    }
}
