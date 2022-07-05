//
//  IngredientsListView.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/5/22.
//

import SwiftUI

struct IngredientsListView: View {

    @State var ingredients: [String]

    //    init(ingredients: [String] = recipesList[0].ingredients) {
    //        self.ingredients = ingredients
    //    }

    func getIngredients(ingredients: [String]) -> [Ingredient] {
        var ingredientsListFinal: [Ingredient] = []
        for ingredient in ingredientsList {
            if ingredients.firstIndex(of: ingredient.name) != nil {
                ingredientsListFinal.append(ingredient)
            }
        }
        return ingredientsListFinal
    }

    var body: some View {

        List(getIngredients(ingredients: ingredients)) { ingredient in
            NavigationLink(ingredient.name, value: ingredient)
        }
        .navigationDestination(for: Ingredient.self) { ingredient in
            IngredientView(ingredient: ingredient)
        }

    }
}


struct IngredientsListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsListView(ingredients: recipesList[0].ingredients)
    }
}
