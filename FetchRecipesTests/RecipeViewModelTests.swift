import XCTest
@testable import FetchRecipes

final class RecipeViewModelTests: XCTestCase {
  var sut: RecipeViewModel!
  var mockInteractor: MockRecipeInteractor!
  var mockImageCache: MockImageCache!
  
  override func setUp() {
    super.setUp()
    mockInteractor = MockRecipeInteractor()
    mockImageCache = MockImageCache()
    sut = RecipeViewModel(interactor: mockInteractor, imageCache: mockImageCache)
  }
  
  override func tearDown() {
    sut = nil
    mockInteractor = nil
    mockImageCache = nil
    super.tearDown()
  }
  
  func testFetchRecipesSuccess() async {
    await sut.fetchRecipes()
    
    XCTAssertEqual(sut.isLoading, false)
    XCTAssertEqual(sut.errorMessage, nil)
    XCTAssertEqual(sut.recipes.count, 2)
  }
  
  func testFetchRecipesFailure() async {
    mockInteractor.shouldFail = true
    
    await sut.fetchRecipes()
    
    XCTAssertEqual(sut.isLoading, false)
    XCTAssertEqual(sut.errorMessage, "The operation couldn’t be completed. (FetchRecipes.NetworkError error 0.)")
    XCTAssertEqual(sut.recipes.isEmpty, true)
  }
  
  func testFilteredRecipesWithSearch() async {
    await sut.fetchRecipes()
    sut.searchText = "Pizza"
    
    XCTAssertEqual(sut.filteredRecipes.count, 1)
    XCTAssertEqual(sut.filteredRecipes.first?.name, "Pizza")
  }
  
  func testFilteredRecipesWithCuisine() async {
    await sut.fetchRecipes()
    sut.filters.toggleCuisine("Italian")
    
    XCTAssertEqual(sut.filteredRecipes.count, 1)
    XCTAssertEqual(sut.filteredRecipes.first?.cuisine, "Italian")
  }
  
  func testSortToggle() async {
    await sut.fetchRecipes()
    
    sut.toggleSort()
    
    XCTAssertEqual(sut.isSortAscending, false)
    XCTAssertEqual(sut.filteredRecipes.first?.name, "Sushi")
  }
  
  func testRowViewModelCaching() async {
    await sut.fetchRecipes()
    let recipe = sut.recipes[0]
    
    let viewModel1 = sut.rowViewModel(for: recipe)
    let viewModel2 = sut.rowViewModel(for: recipe)
    
    XCTAssertTrue(viewModel1 === viewModel2, "Should return cached instance")
  }
  
  func testFetchRecipesClearsCache() async {
    await sut.fetchRecipes()
    let firstRecipe = sut.recipes[0]
    _ = sut.rowViewModel(for: firstRecipe)
    XCTAssertEqual(sut.rowViewModels.count, 1, "precondition")
    
    await sut.fetchRecipes()
    
    XCTAssertEqual(sut.rowViewModels.isEmpty, true)
  }
  
  func testSearchTextEmptyShowsAllRecipes() async {
    await sut.fetchRecipes()
    
    sut.searchText = ""
    
    XCTAssertEqual(sut.filteredRecipes.count, sut.recipes.count)
  }
}
