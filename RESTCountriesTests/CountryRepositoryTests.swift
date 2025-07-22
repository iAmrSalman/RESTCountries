//
//  CountryRepositoryTests.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation
import Testing
@testable import RESTCountries

struct CountryRepositoryTests {
    class MockCountryService: CountryService {
        var countriesToReturn: [Country] = []
        var shouldThrow: Bool = false
        override func fetchAllCountries() async throws -> [Country] {
            if shouldThrow { throw NSError(domain: "Test", code: 1) }
            return countriesToReturn
        }
    }

    class MockCountryStorage: CountryStorageProtocol {
        var savedCountries: [Country] = []
        func save(countries: [Country]) {
            savedCountries = countries
        }
        func load() -> [Country] {
            savedCountries
        }
    }

    @Test func testRepositoryReturnsLocalIfAvailable() async throws {
        let local = [Country(id: "1", name: .init(common: "local", official: "local"), capital: ["L"], currencies: nil, cca2: "L1", flags: .init(png: nil, svg: nil, alt: nil), region: "LR", subregion: "LRS")]
        let storage = MockCountryStorage()
        storage.savedCountries = local
        let repo = CountryRepository(service: MockCountryService(), storage: storage)
        let result = try await repo.getAllCountries()
        #expect(result == local)
    }

    @Test func testRepositoryFallsBackToRemoteAndSaves() async throws {
        let remote = [Country(id: "2", name: .init(common: "remote", official: "remote"), capital: ["R"], currencies: nil, cca2: "R1", flags: .init(png: nil, svg: nil, alt: nil), region: "RR", subregion: "RRS")]
        let storage = MockCountryStorage()
        let service = MockCountryService()
        service.countriesToReturn = remote
        let repo = CountryRepository(service: service, storage: storage)
        let result = try await repo.getAllCountries()
        #expect(result == remote)
        #expect(storage.savedCountries == remote)
    }

    @Test func testRepositoryThrowsOnRemoteError() async throws {
        let storage = MockCountryStorage()
        let service = MockCountryService()
        service.shouldThrow = true
        let repo = CountryRepository(service: service, storage: storage)
        do {
            _ = try await repo.getAllCountries()
            #expect(false) // Should not reach here
        } catch {
            #expect(true)
        }
    }
} 
