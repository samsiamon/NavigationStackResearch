//
//  Recipe.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/1/22.
//

import Foundation

enum RecipeType {
    case breakfast, lunch, dinner, dessert, appatizer, misc
}

class Recipe: Decodable, Identifiable {
    var name: String
    var type: RecipeType
    var description: String
    var ingredients : [Ingredient:Int]
    var id: Int

    init(
        name: String,
        type: RecipeType = .misc,
        description: String = "",
        ingredients: [Ingredient],
        id: Int
    ){
        self.name = name
        self.type = type
        self.description = description
        self.ingredients = ingredients
    }
}
