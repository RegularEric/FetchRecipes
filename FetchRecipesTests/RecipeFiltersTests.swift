import XCTest
@testable import FetchRecipes

final class RecipeFiltersTests: XCTestCase {
  var sut: RecipeFilters!
  
  override func setUp() {
    super.setUp()
    sut = RecipeFilters()
  }
  
  func testInitialize() {
    XCTAssertEqual(sut.cuisineFilters.count, 0, "precondition")
    let recipes = [
      Recipe(id: "1", cuisine: "Italian", name: "Pizza", photoURLSmall: nil),
      Recipe(id: "2", cuisine: "Japanese", name: "Sushi", photoURLSmall: nil)
    ]
    
    sut.initialize(with: recipes)
    
    XCTAssertEqual(sut.cuisineFilters.count, 2)
    XCTAssertEqual(sut.isFiltering, false)
  }
  
  func testToggleCuisine() {
    let recipes = [
      Recipe(id: "1", cuisine: "Italian", name: "Pizza", photoURLSmall: nil)
    ]
    sut.initialize(with: recipes)
    
    XCTAssertEqual(sut.selectedCuisines.count, 0, "precondition")
    
    sut.toggleCuisine("Italian")
    
    XCTAssertEqual(sut.isFiltering, true)
    XCTAssertEqual(sut.selectedCuisines.count, 1)
  }
  
  func testClearAll() {
    let recipes = [
      Recipe(id: "1", cuisine: "Italian", name: "Pizza", photoURLSmall: nil)
    ]
    sut.initialize(with: recipes)
    sut.toggleCuisine("Italian")
    XCTAssertEqual(sut.cuisineFilters.count, 1, "precondition")
    
    sut.clearAll()
    
    XCTAssertEqual(sut.isFiltering, false)
    XCTAssertEqual(sut.selectedCuisines.isEmpty, true)
  }
}
