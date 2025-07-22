//
//  UserDefaultsCountryStorage.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

class UserDefaultsCountryStorage: CountryStorageProtocol {
    private let key = "addedCountriesKey"
    
    func save(countries: [Country]) {
        if let data = try? JSONEncoder().encode(countries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func load() -> [Country] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let countries = try? JSONDecoder().decode([Country].self, from: data) else {
            return []
        }
        return countries
    }
} 
