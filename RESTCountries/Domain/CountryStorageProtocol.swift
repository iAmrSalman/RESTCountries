//
//  CountryStorageProtocol.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

protocol CountryStorageProtocol {
    func save(countries: [Country])
    func load() -> [Country]
} 