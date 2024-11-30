//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import SwiftUI

struct RecipeListView: View {
  @State private var viewModel: any RecipeInforming
  @State private var isFilterSheetPresented = false
  
  init(viewModel: any RecipeInforming) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationStack {
      Group {
        if viewModel.isLoading {
          ProgressView("Loading...")
        }
        if let error = viewModel.errorMessage {
          SimpleMessageView(
            message: error,
            action: { Task { await viewModel.fetchRecipes() }}
          )
        } else if viewModel.recipes.isEmpty {
          SimpleMessageView(
            message: "No Recipes :(",
            action: { Task { await viewModel.fetchRecipes() }})
        } else {
          recipeList
        }
      }
      .navigationTitle("Recipes")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          filterButtons
        }
      }
      .task {
        await viewModel.fetchRecipes()
      }
      .sheet(isPresented: $isFilterSheetPresented) {
        RecipeFilterSheet(filters: $viewModel.filters)
      }
    }
  }
  
  private var recipeList: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 0) {
        ForEach(viewModel.filteredRecipes) { recipe in
          RecipeRow(viewModel: viewModel.rowViewModel(for: recipe))
            .padding()
        }
      }
    }
    .refreshable {
      await viewModel.fetchRecipes()
    }
    .searchable(text: $viewModel.searchText)
  }
  
  private var filterButtons: some View {
    HStack {
      sortButton
      filterButton
    }
  }
  
  private var filterButton: some View {
    Button {
      isFilterSheetPresented = true
    } label: {
      Image(systemName: "line.horizontal.3.decrease.circle")
    }
    .tint(.mint)
  }
  
  private var sortButton: some View {
    Button {
      viewModel.toggleSort()
    } label: {
      Image(systemName: viewModel.isSortAscending ? "arrow.up" : "arrow.down")
    }
    .tint(.mint)
  }
}
