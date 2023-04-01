//
//  File.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/02.
//

import Foundation
import Alamofire

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    // Singleton
    // why?
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        // URLRequest : HTTP Method, body
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/trending/movie/day?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        AF.request(
            url,
            // method: .get,
            // encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"])
        // .validate(statusCode: 200..<300)
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
            
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        /*
        // let session = URLSession(configuration: .default)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            // JSONSerialization throws error -> do { try } catch {}
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                
                completion(.failure(error))
            }
        }
        
        task.resume()
        */
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/trending/tv/day?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        AF.request(
            url,
            headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
            
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/movie/upcoming?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        AF.request(url, headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
                
            case.success(let data):
                completion(.success(data.results))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/movie/popular?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        AF.request(url, headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
                
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/movie/top_rated?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        AF.request(url, headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/discover/movie?api_key=\(Bundle.main.TMDB_API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        AF.request(url, headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        // https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher
        // addingPercentEncoding 특수 문자, 한글 등등 URL에 포함 가능하게 도와줌
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/search/movie?api_key=\(Bundle.main.TMDB_API_KEY)&query=\(query)") else { return }
        
        AF.request(url, headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TitleResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(Constants.Youtube_Base_URL)q=\(query)&key=\(Bundle.main.Youtube_API_KEY)") else { return }
        
        AF.request(url, headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: YoutubeSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.items[0]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
