//
//  File.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/02.
//

import Foundation

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
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/trending/tv/day?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/movie/upcoming?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/movie/popular?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/movie/top_rated?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { return }
            // data decode
            do {
                
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/discover/movie?api_key=\(Bundle.main.TMDB_API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        // https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher
        // addingPercentEncoding 특수 문자, 한글 등등 URL에 포함 가능하게 도와줌
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(Constants.TMDB_base_URL)/3/search/movie?api_key=\(Bundle.main.TMDB_API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(Constants.Youtube_Base_URL)q=\(query)&key=\(Bundle.main.Youtube_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            // error check, data 옵셔널 벗기기
            guard let data = data, error == nil else { return }
            
            // do {} catch {}
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                
            } catch {
                print("get Movie error")
            }
        }
        
        task.resume()
    }
}
