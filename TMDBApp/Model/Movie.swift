//
//  Movie.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 31.08.2022.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int?
    let title: String?
    let overview: String?
    let originalTitle: String?
    let originalName: String?
    let posterPath: String?
    let voteCount: Int
    let voteAverage: Double?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id,title,overview
        case originalTitle = "original_title"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
