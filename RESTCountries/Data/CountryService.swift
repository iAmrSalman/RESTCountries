//
//  CountryService.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

class CountryService {
    private let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,capital,currencies,cca2,flags,region,subregion")!
    
    func fetchAllCountries() async throws -> [Country] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Country].self, from: data)
    }
} 
