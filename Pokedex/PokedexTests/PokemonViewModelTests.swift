//
//  PokemonDetailsViewModelTests.swift
//  Pokedex
//

import XCTest
@testable import Pokedex

final class PokemonViewModelTests: XCTestCase {

    var viewModel: PokemonViewModel!
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = PokemonViewModel(service: mockService, url: "https://pokeapi.co/api/v2/pokemon/1/")
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testGetPokemonDetailsSuccess() {
        let pokemonDetails = Pokemon(baseExperience: 64, height: 7, identifier: 1, name: "Bulbasaur", sprites: Sprites.init(frontDefault: "img_url"), types: [PokemonType(type: TypeDetail(name: "Grass"))], weight: 69)
        mockService.getPokemonDetailsResult = .success(pokemonDetails)

        let expectation = self.expectation(description: "Data fetch success")
        viewModel.onDataLoaded = {
            XCTAssertEqual(self.viewModel.displayName, "Bulbasaur")
            XCTAssertEqual(self.viewModel.displayIdentifier, "ID: 1")
            XCTAssertEqual(self.viewModel.imageUrl, URL(string: "img_url"))
            XCTAssertEqual(self.viewModel.displayHeight, "Height: 7 dm")
            XCTAssertEqual(self.viewModel.displayWeight, "Weight: 69 kg")
            XCTAssertEqual(self.viewModel.displayBaseExperience, "Base XP: 64 XP")
            XCTAssertEqual(self.viewModel.displayTypes, "Types: Grass")
            expectation.fulfill()
        }
        viewModel.fetchPokemonDetails(from: "https://pokeapi.co/api/v2/pokemon/1/")

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPokemonDetailsBadUrlFailure() {
        mockService.getPokemonDetailsResult = .failure(.badUrl)
        let expectation = self.expectation(description: "Data fetch failure")
        viewModel.showErrorAlert = { error in
            XCTAssertEqual(error, NetworkError.badUrl.errorMessage)
            expectation.fulfill()
        }
        viewModel.fetchPokemonDetails(from: "https://pokeapi.co/api/v2/pokemon/1/")

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPokemonDetailsInvalidDataFailure() {
        mockService.getPokemonDetailsResult = .failure(.invalidData)
        let expectation = self.expectation(description: "Data fetch failure")
        viewModel.showErrorAlert = { error in
            XCTAssertEqual(error, NetworkError.invalidData.errorMessage)
            expectation.fulfill()
        }
        viewModel.fetchPokemonDetails(from: "https://pokeapi.co/api/v2/pokemon/1/")

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPokemonDetailsDecodeFailure() {
        mockService.getPokemonDetailsResult = .failure(.decodingError)
        let expectation = self.expectation(description: "Data fetch failure")
        viewModel.showErrorAlert = { error in
            XCTAssertEqual(error, NetworkError.decodingError.errorMessage)
            expectation.fulfill()
        }
        viewModel.fetchPokemonDetails(from: "https://pokeapi.co/api/v2/pokemon/1/")

        waitForExpectations(timeout: 1, handler: nil)
    }
}
