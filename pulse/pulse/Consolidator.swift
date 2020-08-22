//
//  Consolidator.swift
//  pulse
//
//  Created by Adnan Abdulai on 8/15/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import Foundation

struct Consolidator {

    var countryStats = [TrackerCountryModel]()

    func consolidate() -> [TrackerCountryModel] {
        var justCountry = [String]()

        for country in countryStats {
            justCountry.append(country.country)
        }

        let uniqueCountry = Set(justCountry).sorted()
        var cleanedCountryStats = [TrackerCountryModel]()

        for uniq in uniqueCountry {
            var cleanedStat = TrackerCountryModel()
            var confirmed = 0
            var deaths = 0
            var population = 0

            for country in countryStats {
                if uniq == country.country {
                    confirmed += country.confirmed
                    deaths += country.deaths
                    population += country.population
                }
            }
            cleanedStat.country = uniq
            cleanedStat.confirmed = confirmed
            cleanedStat.deaths = deaths
            cleanedStat.population = population
            cleanedCountryStats.append(cleanedStat)

        }
        print(cleanedCountryStats)
        return cleanedCountryStats
    }

}
