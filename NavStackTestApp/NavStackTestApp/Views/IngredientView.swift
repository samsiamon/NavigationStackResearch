//
//  IngredientView.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/1/22.
//

import SwiftUI

struct IngredientView: View {

    @State var ingredient: Ingredient

    init(ingredient: Ingredient = ingredientsList[0]) {
        self.ingredient = ingredient
    }

    var body: some View {
        HStack {
            VStack{
                Text(ingredient.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(ingredient.description)
                    .font(.body)
            }
            .padding()
            if let quantity = ingredient.quantinity {
                Text("\(quantity)")
                    .font(.title2)
            } else {
                EmptyView()
            }
        }

    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView()
            .previewLayout(.sizeThatFits)
    }
}
