//
//  ContentView.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: CountryListViewModel
    @State private var selectedCountry: Country?
    
    init(viewModel: CountryListViewModel = CountryListViewModel(countryRepository: DependencyContainer.shared.countryRepository, locationService: DependencyContainer.shared.locationService)) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Loading countries...")
                        .font(.headline)
                        .padding(.top, 8)
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Text("Oops!")
                            .font(.title2)
                            .bold()
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            Task { await viewModel.fetchCountries() }
                        }) {
                            Text("Retry")
                                .bold()
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(16)
                    .padding()
                    Spacer()
                } else {
                    // Search Bar
                    TextField("Search countries...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .top])
                    // Search Results (for adding)
                    if !viewModel.searchText.isEmpty {
                        List(viewModel.filteredCountries) { country in
                            HStack {
                                if let flagURL = country.flags?.png, let url = URL(string: flagURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: 32, height: 24)
                                    .cornerRadius(4)
                                }
                                Text(country.name.common)
                                Spacer()
                                if !viewModel.addedCountries.contains(where: { $0.id == country.id }) && viewModel.canAddMore {
                                    Button("Add") {
                                        viewModel.addCountry(country)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 200)
                    }
                    // Added Countries
                    List {
                        Section(header: Text("Added Countries (\(viewModel.addedCountries.count)/5)")) {
                            ForEach(viewModel.addedCountries) { country in
                                NavigationLink(destination: CountryDetailView(country: country)) {
                                    CountryRowView(country: country)
                                }
                            }
                            .onDelete { indexSet in
                                indexSet.map { viewModel.addedCountries[$0] }.forEach(viewModel.removeCountry)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("REST Countries")
        }
        .task {
            await viewModel.fetchCountries()
        }
        .alert("Location Access Denied", isPresented: $viewModel.showLocationAlert) {
            Button("OK") {}
        } message: {
            Text("Location access is needed to automatically detect your country. As a default, Egypt has been added to your list.")
        }
    }
}

struct CountryRowView: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: 16) {
            if let flagURL = country.flags?.png, let url = URL(string: flagURL) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 48, height: 32)
                .cornerRadius(4)
                .shadow(radius: 2)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name.common)
                    .font(.headline)
                    .fontWeight(.semibold)
                if let capital = country.capital?.first, !capital.isEmpty {
                    Text(capital)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
}
