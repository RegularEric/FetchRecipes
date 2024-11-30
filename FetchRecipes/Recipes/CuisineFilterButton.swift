//
//  CuisineFilterButton.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import SwiftUI

struct CuisineFilterButton: View {
  let cuisine: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(cuisine)
        .lineLimit(1)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
          Capsule()
            .fill(isSelected ? .mint : .gray.opacity(0.15))
        )
        .foregroundStyle(isSelected ? .white : .primary)
    }
  }
}
