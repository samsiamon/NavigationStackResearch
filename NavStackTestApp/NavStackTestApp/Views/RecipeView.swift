//
//  RecipeView.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/4/22.
//

import SwiftUI

struct RecipeView: View {

    @State var recipe: Recipe

    init(recipe: Recipe = recipesList[0]) {
        self.recipe = recipe
    }

    var body: some View {
        VStack {
            Text(recipe.name)
                .font(.title)
                .fontWeight(.bold)
            Text(recipe.description)
                .font(.body)
            IngredientsListView(ingredients: recipe.ingredients)
        }
    }
}



struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}
