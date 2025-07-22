//
//  CountryDetailView.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    if let flagURL = country.flags?.png, let url = URL(string: flagURL) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 120, height: 80)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    }
                    Text(country.name.common)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    detailRow(label: "Capital", value: country.capital?.first)
                    detailRow(label: "Region", value: country.region)
                    detailRow(label: "Subregion", value: country.subregion)
                }
                
                if let currencies = country.currencies, let first = currencies.first?.value {
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Currency")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        if let name = first.name {
                            detailRow(label: "Name", value: name)
                        }
                        if let symbol = first.symbol {
                            detailRow(label: "Symbol", value: symbol)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func detailRow(label: String, value: String?) -> some View {
        if let value = value, !value.isEmpty {
            HStack {
                Text(label)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}
