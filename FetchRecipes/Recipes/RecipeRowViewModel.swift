//
//  RecipeRowViewModel.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import SwiftUI

@Observable
final class RecipeRowViewModel {
  let recipe: Recipe
  private let imageCache: ImageCaching
  private(set) var thumbnail: Image?
  private(set) var loadingTask: Task<Void, Never>?
  
  init(recipe: Recipe, imageCache: ImageCaching) {
    self.recipe = recipe
    self.imageCache = imageCache
    loadImage()
  }
  
  func loadImage() {
    guard let url = recipe.photoURLSmall else { return }
    loadingTask?.cancel()
    loadingTask = Task { @MainActor in
      if let image = await imageCache.fetchImage(for: url) {
        thumbnail = Image(uiImage: image)
      }
      loadingTask = nil
    }
  }
  
  deinit {
    loadingTask?.cancel()
  }
}
