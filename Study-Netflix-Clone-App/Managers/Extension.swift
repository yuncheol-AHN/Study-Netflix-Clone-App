//
//  Constants.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/03/02.
//

import Foundation

struct Constants {
    
    static let base_URL = "https://api.themoviedb.org"
    static let YoutubeBase_URL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let YoutubeAPI_KEY = "AIzaSyCXicAaBEHeqeuh4M41S6GmK52C3LyemBw"
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
