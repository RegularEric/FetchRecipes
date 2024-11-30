import Foundation
@testable import FetchRecipes

final class MockNetworkClient: Networking {
  var shouldFail = false
  var mockData: Decodable?
  var lastRequest: URLRequest?
  
  func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T {
    lastRequest = request
    
    if shouldFail {
      throw NetworkError.requestFailed(description: "Mock network failure")
    }
    
    if let mockData = mockData as? T {
      return mockData
    }
    
    // Default mock data for RecipeResponse
    if T.self == [Recipe].self {
      let recipes = [
        Recipe(id: "1", cuisine: "Italian", name: "Pizza", photoURLSmall: nil),
        Recipe(id: "2", cuisine: "Japanese", name: "Sushi", photoURLSmall: nil)
      ]
      return recipes as! T
    }
    
    throw NetworkError.invalidData
  }
}
