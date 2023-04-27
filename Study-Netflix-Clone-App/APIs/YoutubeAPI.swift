//
//  YoutubeAPI.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/04/25.
//

import Foundation
import Moya

enum YoutubeAPI {
    case trailerVideo(searchQuery: String)
}

extension YoutubeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://youtube.googleapis.com/youtube")!
    }
    
    var path: String {
        switch self {
        case .trailerVideo:
            return "/v3/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .trailerVideo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trailerVideo(let searchQuery):
            let params = ["q":"\(searchQuery)", "key": "\(Bundle.main.Youtube_API_KEY)"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
