//
//  RecipeInteractor.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import Foundation

protocol RecipeInteracting {
  func fetchRecipes() async -> Result<[Recipe], Error>
}

final class RecipeInteractor: RecipeInteracting {
  private let client: Networking
  private let url: String
  
  init(client: Networking = NetworkClient(), endpoint: Endpoint = .normal) {
    self.client = client
    self.url = endpoint.url
  }
  
  enum Endpoint {
    case normal
    case malformed
    case empty
    
    var url: String {
      switch self {
      case .normal:
        return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
      case .malformed:
        return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
      case .empty:
        return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
      }
    }
  }
  
  func fetchRecipes() async -> Result<[Recipe], Error> {
    guard let url = URL(string: url) else {
      return .failure(NetworkError.invalidURL)
    }
    
    do {
      let response = try await client.fetch(type: RecipeResponse.self, with: URLRequest(url: url))
      return .success(response.recipes)
    } catch {
      print("failed", error)
      return .failure(NetworkError.requestFailed(description: error.localizedDescription))
    }
  }
}


/// This can be public & generic if our backend handles all responses with a pagination with some data.
private struct RecipeResponse: Codable {
  let recipes: [Recipe]
  // let pagination: Pagination?
}
