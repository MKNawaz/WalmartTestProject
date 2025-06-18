//
//  FetchCountriesUseCase.swift
//  WalmartTestProject
//
//  Created by Khurram Nawaz on 6/17/25.
//
import Foundation

protocol FetchCountriesUseCaseService {
    func execute() async throws -> [Country]
}


class FetchCountriesUseCase: FetchCountriesUseCaseService {
    private let networkingService: NetworkingService
    private let dataStore: DataStoreService

    init(networkingService: NetworkingService, dataStore: DataStoreService) {
        self.networkingService = networkingService
        self.dataStore = dataStore
    }

    func execute() async throws -> [Country] {
        let countries = try await networkingService.fetchCountries()
        await dataStore.setCountries(countries)
        return countries
    }
}
