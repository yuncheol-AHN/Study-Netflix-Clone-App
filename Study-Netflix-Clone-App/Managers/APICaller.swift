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
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        // URLRequest : HTTP Method, body
        guard let url = URL(string: "\(Constants.base_URL)/3/trending/movie/day?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        // https://openapi.naver.com/v1/search/image?query=qi9r5xBgcc9KTxlOLjssEbDgO0J.jpg
        //
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
        
        guard let url = URL(string: "\(Constants.base_URL)/3/trending/tv/day?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
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
        
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/upcoming?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
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
        
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/popular?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
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
        
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/top_rated?api_key=\(Bundle.main.TMDB_API_KEY)") else { return }
        
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
}
