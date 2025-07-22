//
//  LocationServiceProtocol.swift
//  RESTCountries
//
//  Created by Amr Salman on 22/07/2025.
//

import Foundation
import Combine

protocol LocationServiceProtocol {
    var countryCodePublisher: Published<String?>.Publisher { get }
    var permissionDeniedPublisher: Published<Bool>.Publisher { get }
    func requestLocation()
} 