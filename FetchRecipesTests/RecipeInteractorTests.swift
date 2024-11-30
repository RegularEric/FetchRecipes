//
//  RecipeInteractorTests.swift
//  FetchRecipesTests
//
//  Created by Eric Chang on 11/29/24.
//

import XCTest
@testable import FetchRecipes

class RecipeInteractorTests: XCTestCase {
  var sut: RecipeInteractor!
  var mockClient: MockNetworkClient!
  
  override func setUp() {
    super.setUp()
    mockClient = MockNetworkClient()
    sut = RecipeInteractor(client: mockClient)
  }
  
  func testFetchRecipes() async throws {
    let mockService = MockRecipeInteractor()
    let results = await mockService.fetchRecipes()
    
    switch results {
    case .failure: XCTFail()
    case let .success(recipes): XCTAssertEqual(recipes.count, 2)
    }
  }
  
  func testFetchRecipesNetworkFailure() async {
    mockClient.shouldFail = true
    
    let result = await sut.fetchRecipes()
    
    if case .failure = result {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected network failure")
    }
  }
}
