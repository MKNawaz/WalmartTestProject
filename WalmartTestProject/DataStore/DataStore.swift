//
//  DataStore.swift
//  WalmartTestProject
//
//  Created by Khurram Nawaz on 6/17/25.
//
import Foundation

protocol DataStoreService: AnyObject {
    func setCountries(_ countries: [Country]) async
    func getCountries() async -> [Country]
}

// MARK: Implementation
actor DataStore: DataStoreService {
    private(set) var countries: [Country] = []

    func setCountries(_ countries: [Country]) {
        self.countries = countries
    }

    func getCountries() -> [Country] {
        return countries
    }
}
