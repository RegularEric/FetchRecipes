//
//  RecipeViewModel.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import Foundation
import SwiftUI

@MainActor
protocol RecipeInforming {
  var recipes: [Recipe] { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get }
  var searchText: String { get set }
  var filteredRecipes: [Recipe] { get }
  var imageCache: ImageCaching { get }
  var filters: RecipeFilters { get set }
  var isSortAscending: Bool { get }

  func fetchRecipes() async
  func toggleSort()
  func rowViewModel(for recipe: Recipe) -> RecipeRowViewModel
}

@MainActor @Observable
final class RecipeViewModel: RecipeInforming {
  private let interactor: RecipeInteracting
  private(set) var imageCache: ImageCaching
  private(set) var rowViewModels: [String: RecipeRowViewModel] = [:]

  private(set) var recipes: [Recipe] = []
  var filters = RecipeFilters()

  private(set) var isLoading = false
  private(set) var errorMessage: String?
  var searchText: String = ""
  var isSortAscending = true
  
  var filteredRecipes: [Recipe] {
    let searchedRecipes = recipes.filter {
      searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
    }
    let filteredRecipes = filters.isFiltering ? 
      searchedRecipes.filter { filters.selectedCuisines.contains($0.cuisine) } :
      searchedRecipes
    
    return filteredRecipes.sorted { 
      isSortAscending ? $0.name < $1.name : $0.name > $1.name 
    }
  }
  
  init(interactor: RecipeInteracting = RecipeInteractor(), imageCache: ImageCaching) {
    self.interactor = interactor
    self.imageCache = imageCache
  }
  
  func rowViewModel(for recipe: Recipe) -> RecipeRowViewModel {
    if let existing = rowViewModels[recipe.id] {
      return existing
    }
    let newViewModel = RecipeRowViewModel(recipe: recipe, imageCache: imageCache)
    rowViewModels[recipe.id] = newViewModel
    return newViewModel
  }
  
  func fetchRecipes() async {
    guard !isLoading else { return }
    
    isLoading = true
    errorMessage = nil
    
    for viewModel in rowViewModels.values {
      viewModel.loadingTask?.cancel()
    }
    rowViewModels.removeAll()
    
    let result = await interactor.fetchRecipes()
    isLoading = false
    
    switch result {
    case let .success(recipes):
      self.recipes = recipes
      updateFilters()
    case let .failure(error):
      errorMessage = error.localizedDescription
    }
  }
  
  func updateFilters() {
    if filters.cuisineFilters.isEmpty {
      filters.initialize(with: recipes)
    }
  }
  
  func toggleSort() {
    isSortAscending.toggle()
  }
}
