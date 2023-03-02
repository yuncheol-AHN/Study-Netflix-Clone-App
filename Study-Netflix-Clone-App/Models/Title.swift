//
//  Movies.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/02/23.
//

import Foundation

struct TitleResponse: Codable {
    
    let results: [Title]
}

struct Title: Codable {
    
    let id: Int?
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let original_language: String?
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
    let vote_count: Double?
}
