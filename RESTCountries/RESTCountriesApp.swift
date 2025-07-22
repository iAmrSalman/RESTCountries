//
//  RESTCountriesApp.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import SwiftUI

@main
struct RESTCountriesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: DependencyContainer.shared.makeCountryListViewModel())
        }
    }
}
