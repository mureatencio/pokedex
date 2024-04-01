//
//  MockData.swift
//  Pokedex
//

import Foundation

class MockData {
    static let shortPokemonListJSON = """
        {
          "count": 1126,
          "next": "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20",
          "previous": null,
          "results": [
            {
              "name": "bulbasaur",
              "url": "https://pokeapi.co/api/v2/pokemon/1/"
            },
            {
              "name": "ivysaur",
              "url": "https://pokeapi.co/api/v2/pokemon/2/"
            }
          ]
        }
        """
    
    static let pokemonDetailsJSON = """
        {
           "base_experience": 64,
           "height": 7,
           "id": 1,
           "name": "bulbasaur",
           "sprites": {
              "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
           },
           "types": [
              {
                 "type": {
                    "name": "grass"
                 }
              },
              {
                 "type": {
                    "name": "poison"
                 }
              }
           ],
           "weight": 69
        }
        """
    
    static let pokemonDetailsInvalidJSON = """
        {
           "id": 1,
           "name": "bulbasaur",
           // Missing many required fields
        }
        """
}
