//
//  PokemonListViewTests.swift
//  Pokedex
//

import XCTest
@testable import Pokedex

final class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = PokemonListViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testGetPokemonListSuccess() {
        // Setup success scenario in mockService
        let pokemonList = [PokemonListItem(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")]
        let response = PokemonServiceResponse(count: 1, next: nil, previous: nil, results: pokemonList)
        mockService.getPokemonCharactersResult = .success(response)

        let expectation = self.expectation(description: "Data fetch success")
        viewModel.reloadTableViewRows = { indexPaths in
            XCTAssertEqual(indexPaths.count, 1)
            XCTAssertEqual(self.viewModel.pokemonViewModels.count, 1)
            XCTAssertEqual(self.viewModel.pokemonViewModels.first?.name, "Bulbasaur")
            expectation.fulfill()
        }

        viewModel.getPokemonList()

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPokemonListBadUrlFailure() {
        // Setup failure scenario in mockService
        mockService.getPokemonCharactersResult = .failure(NetworkError.badUrl)

        let expectation = self.expectation(description: "Data fetch failure")
        viewModel.showErrorAlert = { message in
            XCTAssertEqual(message, NetworkError.badUrl.errorMessage)
            expectation.fulfill()
        }
        viewModel.getPokemonList()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPokemonListInvalidDataFailure() {
        // Setup failure scenario in mockService
        mockService.getPokemonCharactersResult = .failure(NetworkError.invalidData)

        let expectation = self.expectation(description: "Data fetch failure")
        viewModel.showErrorAlert = { message in
            XCTAssertEqual(message, NetworkError.invalidData.errorMessage)
            expectation.fulfill()
        }
        viewModel.getPokemonList()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPokemonListDecodeFailure() {
        // Setup failure scenario in mockService
        mockService.getPokemonCharactersResult = .failure(NetworkError.decodingError)

        let expectation = self.expectation(description: "Data fetch failure")
        viewModel.showErrorAlert = { message in
            XCTAssertEqual(message, NetworkError.decodingError.errorMessage)
            expectation.fulfill()
        }
        viewModel.getPokemonList()
        waitForExpectations(timeout: 1, handler: nil)
    }
}
