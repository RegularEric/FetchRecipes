import XCTest
@testable import FetchRecipes

final class RecipeRowViewModelTests: XCTestCase {
  var sut: RecipeRowViewModel!
  var mockImageCache: MockImageCache!
  
  override func setUp() {
    super.setUp()
    mockImageCache = MockImageCache()
  }
  
  func testLoadImageCancelsExistingTask() async {
    let recipe = Recipe(id: "1",
                        cuisine: "Italian",
                        name: "Pizza",
                        photoURLSmall: URL(string: "https://example.com/image.jpg"))
    sut = RecipeRowViewModel(recipe: recipe, imageCache: mockImageCache)
    
    let firstTask = sut.loadingTask
    sut.loadImage()
    
    XCTAssertNotEqual(firstTask, sut.loadingTask)
  }
  
  func testDeinitCancelsLoadingTask() {
    let recipe = Recipe(id: "1",
                        cuisine: "Italian",
                        name: "Pizza",
                        photoURLSmall: URL(string: "https://example.com/image.jpg"))
    
    sut = RecipeRowViewModel(recipe: recipe, imageCache: mockImageCache)
    XCTAssertNotNil(sut.loadingTask)
  }
}
