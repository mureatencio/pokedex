//
//  APIServiceTests.swift
//  Pokedex
//

import XCTest
@testable import Pokedex

final class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        apiService = APIService(session: mockSession)
    }
    
    func testGetPokemonCharactersSuccess() {
        // Expectation for waiting the async call to finish
        let expectation = self.expectation(description: "Successful fetch of Pokémon characters")

        // Setup mock data
        let mockData = MockData.shortPokemonListJSON.data(using: .utf8)
        
        mockSession.mockData = mockData
        mockSession.mockError = nil

        // Call getPokemonCharacters
        apiService.getPokemonCharacters(offset: 0) { result in
            switch result {
            case .success(let response):
                // Assert that we receive the expected result
                XCTAssertNotNil(response)
                XCTAssertEqual(response.count, 1126)
                XCTAssertEqual(response.results.count, 2)
                XCTAssertEqual(response.results.first?.name, "bulbasaur")
                XCTAssertEqual(response.results.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
            case .failure(let error):
                XCTFail("Expected successful fetch, but got error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetPokemonCharactersFailureInvalidData() {
        // Expectation for waiting the async call to finish
        let expectation = self.expectation(description: "Fetch of Pokémon characters fails due to bad URL")

        mockSession.mockData = nil
        mockSession.mockError = nil

        // Call getPokemonCharacters
        apiService.getPokemonCharacters(offset: 0) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to bad URL, but got success")
            case .failure(let error):
                // Assert the error is of type .invalidData
                XCTAssertEqual(error, .invalidData, "Expected .badUrl error, but got \(error)")
            }
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetPokemonDetailsSuccess() {
        let expectation = self.expectation(description: "Successful fetch of Pokémon details")

        // Mock data
        let mockData = MockData.pokemonDetailsJSON.data(using: .utf8)
        mockSession.mockData = mockData
        mockSession.mockError = nil

        let validUrl = "https://pokeapi.co/api/v2/pokemon/1/"
        apiService.getPokemonDetails(for: validUrl) { result in
            switch result {
            case .success(let pokemon):
                // Assertions for top-level properties
                XCTAssertEqual(pokemon.baseExperience, 64)
                XCTAssertEqual(pokemon.height, 7)
                XCTAssertEqual(pokemon.identifier, 1)
                XCTAssertEqual(pokemon.name, "bulbasaur")
                XCTAssertEqual(pokemon.weight, 69)

                // Assertions for nested structures
                XCTAssertEqual(pokemon.sprites.frontDefault, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")

                // Assertions for types array
                XCTAssertEqual(pokemon.types.count, 2)
                XCTAssertEqual(pokemon.types[0].type.name, "grass")
                XCTAssertEqual(pokemon.types[1].type.name, "poison")

            case .failure(let error):
                XCTFail("Expected successful fetch, got error \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetPokemonDetailsFailureDecodingError() {
        let expectation = self.expectation(description: "Fetch of Pokémon details fails due to decoding error")

        // Mock data with missing required fields
        let mockData = MockData.pokemonDetailsInvalidJSON.data(using: .utf8)
        mockSession.mockData = mockData
        mockSession.mockError = nil

        let validUrl = "https://pokeapi.co/api/v2/pokemon/1/"
        apiService.getPokemonDetails(for: validUrl) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to decoding error, but got success")

            case .failure(let error):
                XCTAssertEqual(error, .decodingError, "Expected .decodingError error, but got \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetPokemonDetailsFailureBadUrlError() {
        let expectation = self.expectation(description: "Fetch of Pokémon details fails due to decoding error")
        
        mockSession.mockData = nil
        mockSession.mockError = nil

        let invalidUrl = ""
        apiService.getPokemonDetails(for: invalidUrl) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to decoding error, but got success")

            case .failure(let error):
                XCTAssertEqual(error, .badUrl, "Expected .decodingError error, but got \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }


    func testLocalizationOfErrorMessageForBadUrlError() {
        // Default testing locale is English
        let error = NetworkError.badUrl
        
        let expectedErrorMessage = NSLocalizedString("Error_BadUrl", comment: "Invalid URL error")

        // Assert that the error message is correctly localized
        XCTAssertEqual(error.errorMessage, expectedErrorMessage, "The error message for .badUrl is not correctly localized.")
    }
    
    func testLocalizationOfErrorMessageForInvalidDataError() {
        // Default testing locale is English
        let error = NetworkError.invalidData
        
        let expectedErrorMessage = NSLocalizedString("Error_InvalidData", comment: "Invalid data error")

        // Assert that the error message is correctly localized
        XCTAssertEqual(error.errorMessage, expectedErrorMessage, "The error message for .invalidData is not correctly localized.")
    }
    
    func testLocalizationOfErrorMessageForDecodingError() {
        // Default testing locale is English
        let error = NetworkError.decodingError
        
        let expectedErrorMessage = NSLocalizedString("Error_DecodingError", comment: "Decoding error")

        // Assert that the error message is correctly localized
        XCTAssertEqual(error.errorMessage, expectedErrorMessage, "The error message for .decodingError is not correctly localized.")
    }

}
