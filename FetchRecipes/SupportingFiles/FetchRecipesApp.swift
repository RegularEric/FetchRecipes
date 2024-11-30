//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    /// We can also define our dependencies here like Networker / Analyrics / etc. if we want to inject them into some parent container or multiple tabs if we have more features.
    var body: some Scene {
        WindowGroup {
          RecipeListView(viewModel: RecipeViewModel(interactor: RecipeInteractor(), imageCache: ImageCache()))
        }
    }
}
