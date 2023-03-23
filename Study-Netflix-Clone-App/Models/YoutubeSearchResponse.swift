//
//  YoutubeSearchResponse.swift
//  Study-Netflix-Clone-App
//
//  Created by 안윤철 on 2023/03/17.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementId
}

struct VideoElementId: Codable {
    let kind: String
    let videoId: String
}
