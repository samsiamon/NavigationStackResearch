//
//  RecipeListView.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/5/22.
//

import SwiftUI

struct RecipeListView: View {

    @State var recipes: [Recipe]

    var body: some View {
        NavigationStack {
            List(recipes) { recipe in
                NavigationLink(value: recipe, label: {RecipePreviewView(recipePreview: recipe)})
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeView(recipe: recipe)
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(recipes: recipesList)
    }
}

struct ButtonView: View {
    var body: some View {
        Button("Select") {

        }
    }
}
