//
//  RESTCountriesTests.swift
//  RESTCountriesTests
//
//  Created by Amr Salman on 22/07/2025.
//

import Testing
@testable import RESTCountries

struct RESTCountriesTests {
    @Test func testUserDefaultsCountryStorageSaveAndLoad() async throws {
        let storage = UserDefaultsCountryStorage()
        let countries = [Country(id: "1", name: .init(common: "Test", official: "Test"), capital: ["T"], currencies: nil, cca2: "T1", flags: .init(png: nil, svg: nil, alt: nil), region: "LR", subregion: "LRS")]
        storage.save(countries: countries)
        let loaded = storage.load()
        #expect(loaded.contains(where: { $0.name.common == "Test" }))
    }
}
