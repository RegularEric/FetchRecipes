//
//  MockRecipeInteractor.swift
//  FetchRecipesTests
//
//  Created by Eric Chang on 11/29/24.
//

import XCTest
@testable import FetchRecipes

final class MockRecipeInteractor: RecipeInteracting {
  var shouldFail = false
  
  func fetchRecipes() async -> Result<[Recipe], Error> {
    if shouldFail {
      return .failure(NetworkError.requestFailed(description: "Mock error"))
    }
    return .success([
      Recipe(id: "1", cuisine: "Italian", name: "Pizza", photoURLSmall: nil),
      Recipe(id: "2", cuisine: "Japanese", name: "Sushi", photoURLSmall: nil)
    ])
  }
}
