import UIKit
@testable import FetchRecipes

final class MockImageCache: ImageCaching {
  func fetchImage(for url: URL) async -> UIImage? {
    return nil
  }
}
