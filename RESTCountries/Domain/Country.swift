//
//  Country.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    let id: String // Use cca2 as unique id
    let name: Name
    let capital: [String]?
    let currencies: [String: Currency]?
    let cca2: String
    let flags: Flag?
    let region: String?
    let subregion: String?
    
    struct Name: Codable, Equatable {
        let common: String
        let official: String
    }
    
    struct Currency: Codable, Equatable {
        let name: String?
        let symbol: String?
    }
    
    struct Flag: Codable, Equatable {
        let png: String?
        let svg: String?
        let alt: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case name, capital, currencies, cca2, flags, region, subregion
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(Name.self, forKey: .name)
        self.capital = try? container.decode([String].self, forKey: .capital)
        self.currencies = try? container.decode([String: Currency].self, forKey: .currencies)
        self.cca2 = try container.decode(String.self, forKey: .cca2)
        self.flags = try? container.decode(Flag.self, forKey: .flags)
        self.region = try? container.decode(String.self, forKey: .region)
        self.subregion = try? container.decode(String.self, forKey: .subregion)
        self.id = self.cca2
    }
    
    // Memberwise initializer for tests and manual construction
    init(id: String, name: Name, capital: [String]?, currencies: [String: Currency]?, cca2: String, flags: Flag?, region: String?, subregion: String?) {
        self.id = id
        self.name = name
        self.capital = capital
        self.currencies = currencies
        self.cca2 = cca2
        self.flags = flags
        self.region = region
        self.subregion = subregion
    }
} 