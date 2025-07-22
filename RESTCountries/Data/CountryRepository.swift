//
//  CountryRepository.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

class CountryRepository: CountryRepositoryProtocol {
    private let service: CountryService
    private let storage: CountryStorageProtocol
    
    init(service: CountryService = CountryService(), storage: CountryStorageProtocol = UserDefaultsCountryStorage()) {
        self.service = service
        self.storage = storage
    }
    
    func fetchCountries() async throws -> [Country] {
        try await service.fetchAllCountries()
    }
    
    func saveAddedCountries(_ countries: [Country]) async {
        storage.save(countries: countries)
    }
    
    func loadAddedCountries() async -> [Country] {
        storage.load()
    }
    
    func getAllCountries() async throws -> [Country] {
        let local = storage.load()
        if !local.isEmpty {
            return local
        }
        let remote = try await service.fetchAllCountries()
        storage.save(countries: remote)
        return remote
    }
} 
