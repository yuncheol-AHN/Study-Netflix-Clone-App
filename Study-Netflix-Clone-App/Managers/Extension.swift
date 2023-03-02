//
//  Constants.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/03/02.
//

import Foundation

struct Constants {
    
    static let base_URL = "https://api.themoviedb.org"
}

extension Bundle {
    
    var TMDB_API_KEY: String {
        
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["TMDB_API_KEY"] as? String else {
            fatalError()
        }
        
        return key
    }
}
