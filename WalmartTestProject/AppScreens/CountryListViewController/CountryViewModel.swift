//
//  CountryViewModel.swift
//  WalmartTestProject
//
//  Created by Khurram Nawaz on 6/17/25.
//
import Foundation

struct CountryViewModel {
    let nameRegionCodeLine: String
    let capitalLine: String

    init(from country: Country) {
        nameRegionCodeLine = "\(country.name), \(country.region)\t\t\(country.code)"
        capitalLine = country.capital
    }
}
