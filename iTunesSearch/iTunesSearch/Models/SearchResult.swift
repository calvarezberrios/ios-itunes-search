//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Carlos E. Alvarez-Berrios on 4/14/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let title: String
    let creator: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults: Codable {
    let results: [SearchResult]
}
