//
//  RecipeFilterSheet.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import Flow
import SwiftUI

struct RecipeFilterSheet: View {
  @Binding var filters: RecipeFilters
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      ScrollView {
        HFlow {
          ForEach(filters.cuisineFilters.keys.sorted(), id: \.self) { cuisine in
            CuisineFilterButton(
              cuisine: cuisine,
              isSelected: filters.cuisineFilters[cuisine] ?? false
            ) {
              filters.toggleCuisine(cuisine)
            }
          }
        }
        .navigationTitle("Filter by Cuisine")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Save") {
              dismiss()
            }
            .tint(.mint)
          }
          ToolbarItem(placement: .topBarLeading) {
            Button("Clear All") {
              filters.clearAll()
              dismiss()
            }
            .tint(.mint)
          }
        }
      }
    }
  }
}
