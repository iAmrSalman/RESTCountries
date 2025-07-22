//
//  CountryRepositoryProtocol.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

protocol CountryRepositoryProtocol {
    func fetchCountries() async throws -> [Country]
    func saveAddedCountries(_ countries: [Country]) async
    func loadAddedCountries() async -> [Country]
    func getAllCountries() async throws -> [Country]
} 