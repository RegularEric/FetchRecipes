//
//  SimpleMessageView.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import SwiftUI

struct SimpleMessageView: View {
  let message: String
  let action: () -> Void
  
  var body: some View {
    VStack {
      Text(message)
      Button("Retry") { action() }
        .buttonStyle(.borderedProminent)
        .tint(.mint)
    }
  }
}
