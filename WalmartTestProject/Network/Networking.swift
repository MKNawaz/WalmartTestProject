//
//  Networking.swift
//  WalmartTestProject
//
//  Created by Khurram Nawaz on 6/17/25.
//
import Foundation

protocol NetworkingService {
    func fetchCountries() async throws -> [Country]
}


// MARK: - Implementation -
actor Networking: NetworkingService {
    private let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json")!

    func fetchCountries() async throws -> [Country] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let countries = try JSONDecoder().decode([Country].self, from: data)
        return countries
    }
}
