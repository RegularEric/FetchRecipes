//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import Foundation

struct Recipe: Codable, Equatable, Identifiable {
    let id: String
    let cuisine: String
    let name: String
    let photoURLSmall: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoURLSmall = "photo_url_small"
    }
}
