//
//  RecipeRow.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import SwiftUI

struct RecipeRow: View {
  let viewModel: RecipeRowViewModel
  
  var body: some View {
    HStack {
      if let image = viewModel.thumbnail {
        image
          .resizable()
          .frame(width: 50, height: 50)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      VStack(alignment: .leading) {
        Text(viewModel.recipe.name).font(.headline)
        Text(viewModel.recipe.cuisine).font(.subheadline)
      }
    }
  }
}
