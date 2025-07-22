//
//  DependencyContainer.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    // MARK: - Services & Repositories
    let countryRepository: CountryRepositoryProtocol
    let locationService: LocationServiceProtocol
    
    // MARK: - ViewModels
    func makeCountryListViewModel() -> CountryListViewModel {
        CountryListViewModel(countryRepository: countryRepository, locationService: locationService)
    }
    
    private init() {
        self.countryRepository = CountryRepository()
        self.locationService = LocationService()
    }
} 
