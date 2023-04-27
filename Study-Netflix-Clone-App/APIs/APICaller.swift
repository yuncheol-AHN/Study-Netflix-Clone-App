//
//  File.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/02.
//

import Foundation
import Alamofire
import Moya

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    // Singleton
    static let shared = APICaller()
    
    // Weekly Top 10
    func getTrendingAllWeekly(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let provider = MoyaProvider<TMDBAPI>()
        
        provider.request(.trendingAllWeekly) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(TitleResponse.self) else { return }
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Upcoming Movies
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let provider = MoyaProvider<TMDBAPI>()
        
        provider.request(.upComingMovies) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(TitleResponse.self) else { return }
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Popular Movies
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let provider = MoyaProvider<TMDBAPI>()
        
        provider.request(.popularMovies) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(TitleResponse.self) else { return }
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Top Rated Movies
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        let provider = MoyaProvider<TMDBAPI>()
        
        provider.request(.topRatedMovies) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(TitleResponse.self) else { return }
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Search Movies
    func searchMovies(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        // addingPercentEncoding 특수 문자, 한글 등등 URL에 포함 가능하게 도와줌
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let provider = MoyaProvider<TMDBAPI>()
        
        provider.request(.searchMovies(searchQuery: query)) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(TitleResponse.self) else { return }
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Get Trailer Video from Youtube
    func getTrailerVideo(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let provider = MoyaProvider<YoutubeAPI>()
        
        provider.request(.trailerVideo(searchQuery: query)) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(YoutubeSearchResponse.self) else { return }
                completion(.success(data.items[0]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
