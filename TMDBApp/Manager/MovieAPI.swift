//
//  MovieAPI.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 31.08.2022.
//

import Foundation

struct Constants {
    static let API_KEY = "8f00e8239a6d8dc2a05fcbfadafce502"
    static let baseURL = "https://api.themoviedb.org"
}

enum MovieAPIEndpoint {
    case nowPlaying
    case upcoming
    case upcomingMovies(page: Int)
    case movieDetail(id: Int)
    
    var urlString: String {
        switch self {
        case .nowPlaying:
            return Constants.baseURL + "/3/movie/now_playing?api_key=" + Constants.API_KEY
        case .upcoming:
            return Constants.baseURL + "/3/movie/upcoming?api_key=" + Constants.API_KEY
        case .movieDetail(let id):
            return Constants.baseURL + "/3/movie/\(id)?api_key=" + Constants.API_KEY
        case .upcomingMovies(let page):
            return Constants.baseURL + "/3/movie/upcoming?api_key=" + Constants.API_KEY + "&page=\(page)"
        }
    }
}

enum MovieAPIError: Error {
    case failedToGetData
}

class MovieAPI {
    static let shared = MovieAPI()
    
    func getNowPlayingMovies() async -> Result<[Movie],Error> {
        guard let url = URL(string: MovieAPIEndpoint.nowPlaying.urlString) else { return .failure(MovieAPIError.failedToGetData)}
            
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let movies = try JSONDecoder().decode(NowPlaying.self,from: data)
            return .success(movies.results)
        }catch {
            return .failure(error)
        }
    }
    
    func getUpcomingMoviesResult(page: Int) async -> Result<Upcoming,Error> {
        guard let url = URL(string: MovieAPIEndpoint.upcomingMovies(page: page).urlString) else { return .failure(MovieAPIError.failedToGetData)}
            
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Upcoming.self,from: data)
            return .success(response)
        }catch {
            return .failure(error)
        }
    }
    
    func getUpcomingMovies() async -> Result<[Movie],Error> {
        guard let url = URL(string: MovieAPIEndpoint.upcoming.urlString) else { return .failure(MovieAPIError.failedToGetData)}
            
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let movies = try JSONDecoder().decode(Upcoming.self,from: data)
            return .success(movies.results)
        }catch {
            return .failure(error)
        }
    }
    
    func getMovieDetail(id: Int) async -> Result<Movie,Error> {
        guard let url = URL(string: MovieAPIEndpoint.movieDetail(id: id).urlString) else { return .failure(MovieAPIError.failedToGetData)}
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let movie = try JSONDecoder().decode(Movie.self,from: data)
            return .success(movie)
        }catch {
            return .failure(error)
        }
    }
}
