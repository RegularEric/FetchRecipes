import XCTest
@testable import FetchRecipes

final class ImageCacheTests: XCTestCase {
  var sut: ImageCache!
  var testImage: UIImage!
  var testURL: URL!
  
  override func setUp() {
    super.setUp()
    sut = ImageCache()
    testImage = UIImage(systemName: "star.fill")!
    testURL = URL(string: "https://example.com/test.jpg")!
  }
  
  override func tearDown() {
    sut = nil
    testImage = nil
    testURL = nil
    super.tearDown()
  }
  
  func testFetchImageReturnsNilForNonExistentImage() async {
    let image = await sut.fetchImage(for: testURL)
    XCTAssertNil(image)
  }
  
  func testFetchImageReturnsCachedImage() async {
    sut.saveImageForTesting(testImage, for: testURL)
    
    let cachedImage = await sut.fetchImage(for: testURL)
    
    XCTAssertNotNil(cachedImage)
  }
}
