//
//  APIExtension.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/04/25.
//

import Foundation
import Moya

enum TMDBAPI {
    
    case trendingAllWeekly
    case upComingMovies
    case popularMovies
    case topRatedMovies
    case searchMovies(searchQuery: String)
}

// get : request body X, url에 요청 포함
extension TMDBAPI: TargetType {
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3")! }

    var path: String {
       
       switch self {
       case .trendingAllWeekly:
           return "/trending/all/week"
       case .upComingMovies:
           return "/movie/upcoming"
       case .popularMovies:
           return "/movie/popular"
       case .topRatedMovies:
           return "/movie/top_rated"
       case .searchMovies:
           return "/search/movie"
       }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .trendingAllWeekly, .upComingMovies, .popularMovies, .topRatedMovies, .searchMovies:
            return .get
        }
    }
    
    // Query String
    var task: Moya.Task {
        
        switch self {
        case .trendingAllWeekly, .upComingMovies, .popularMovies, .topRatedMovies:
            let params = ["api_key": "\(Bundle.main.TMDB_API_KEY)"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .searchMovies(let searchQuery):
            let params = ["api_key": "\(Bundle.main.TMDB_API_KEY)", "query": "\(searchQuery)"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json", "Accept":"application/json"]
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
}
