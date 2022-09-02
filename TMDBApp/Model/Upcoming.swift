//
//  Upcoming.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 1.09.2022.
//

import Foundation

struct Upcoming: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
