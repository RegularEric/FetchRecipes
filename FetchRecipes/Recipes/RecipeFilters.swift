//
//  RecipeFilters.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import Foundation

struct RecipeFilters: Equatable {
  private(set) var cuisineFilters: [String: Bool] = [:]
  
  var isFiltering: Bool {
    cuisineFilters.values.contains(true)
  }
  
  var selectedCuisines: Set<String> {
    Set(cuisineFilters.filter { $0.value }.keys)
  }
  
  mutating func initialize(with recipes: [Recipe]) {
    let cuisines = Array(Set(recipes.map(\.cuisine))).sorted()
    cuisineFilters = Dictionary(uniqueKeysWithValues: cuisines.map { ($0, false) })
  }
  
  mutating func toggleCuisine(_ cuisine: String) {
    cuisineFilters[cuisine]?.toggle()
  }
  
  mutating func clearAll() {
    cuisineFilters = Dictionary(uniqueKeysWithValues: cuisineFilters.keys.map { ($0, false) })
  }
}
