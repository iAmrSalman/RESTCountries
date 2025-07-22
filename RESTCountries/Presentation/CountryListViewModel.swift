//
//  CountryListViewModel.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation
import Combine

class CountryListViewModel: ObservableObject {
    @Published var allCountries: [Country] = []
    @Published var searchText: String = ""
    @Published var filteredCountries: [Country] = []
    @Published var addedCountries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showLocationAlert = false

    private let countryRepository: CountryRepositoryProtocol
    private let locationService: LocationServiceProtocol
    private var didSetInitialCountry = false
    private var cancellables = Set<AnyCancellable>()
    private let maxCountries = 5
    
    // Dependency Injection initializer
    init(countryRepository: CountryRepositoryProtocol, locationService: LocationServiceProtocol) {
        self.countryRepository = countryRepository
        self.locationService = locationService
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterCountries(with: text)
            }
            .store(in: &cancellables)
        
        locationService.countryCodePublisher
            .sink { [weak self] code in
                guard let self = self, let code = code, !self.didSetInitialCountry else { return }
                if let country = self.allCountries.first(where: { $0.cca2 == code }) {
                    self.addCountry(country)
                    self.didSetInitialCountry = true
                }
            }
            .store(in: &cancellables)

        locationService.permissionDeniedPublisher
            .sink { [weak self] denied in
                guard let self = self, denied, !self.didSetInitialCountry else { return }
                // Add default country (Egypt)
                if let country = self.allCountries.first(where: { $0.name.common == "Egypt" }) {
                    self.addCountry(country)
                    self.didSetInitialCountry = true
                    self.showLocationAlert = true
                }
            }
            .store(in: &cancellables)
        
        Task {
            await loadAddedCountries()
            await fetchCountries()
        }
    }
    
    @MainActor
    func fetchCountries() async {
        isLoading = true
        errorMessage = nil
        do {
            let countries = try await countryRepository.getAllCountries()
            self.allCountries = countries.sorted { $0.name.common < $1.name.common }
            self.filterCountries(with: self.searchText)
            // Request location after countries are loaded
            if self.addedCountries.isEmpty {
                self.locationService.requestLocation()
            }
        } catch {
            errorMessage = "Failed to load countries. Please try again."
            print("Failed to fetch countries: \(error)")
        }
        isLoading = false
    }
    
    func filterCountries(with text: String) {
        if text.isEmpty {
            filteredCountries = allCountries
        } else {
            filteredCountries = allCountries.filter { $0.name.common.range(of: text, options: .caseInsensitive) != nil }
        }
    }
    
    func addCountry(_ country: Country) {
        guard addedCountries.count < maxCountries else { return }
        guard !addedCountries.contains(country) else { return }
        addedCountries.append(country)
        Task { await saveAddedCountries() }
    }
    
    func removeCountry(_ country: Country) {
        addedCountries.removeAll { $0 == country }
        Task { await saveAddedCountries() }
    }
    
    var canAddMore: Bool {
        addedCountries.count < maxCountries
    }
    
    @MainActor
    func saveAddedCountries() async {
        await countryRepository.saveAddedCountries(addedCountries)
    }
    
    @MainActor
    func loadAddedCountries() async {
        let loaded = await countryRepository.loadAddedCountries()
        self.addedCountries = loaded
        if !loaded.isEmpty {
            self.didSetInitialCountry = true
        }
    }
}
