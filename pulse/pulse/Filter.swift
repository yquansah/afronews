//
//  Filter.swift
//  pulse
//
//  Created by Adnan Abdulai on 7/14/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

enum Topic: String {
        case business
        case tech
        case sports
        case entertianment
        case politics
    }

enum Country: String {
    case ghana
    case togo
    case benin 
    case nigeria
}

class Filter {
    var topics: [Topic]
    var countries: [Country]
    var dateRange: DateInterval?

    init(topics: [Topic], countries: [Country], dateRange: DateInterval?) {
        self.topics = topics
        self.countries = countries
        self.dateRange = dateRange
    }
}
