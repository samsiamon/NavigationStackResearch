//
//  Recipe.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/1/22.
//

import Foundation

enum RecipeType: Decodable {
    case breakfast, lunch, dinner, dessert, appatizer, misc
}

struct Recipe: Identifiable, Hashable, Codable {
    var name: String
    var type: String
    var description: String
    var ingredients: [String]
    var ingredientsCount: [Int]
    var id: Int

    init(
        name: String,
        type: String = "misc",
        description: String = "",
        ingredients: [String],
        ingredientsCount: [Int],
        id: Int
    ){
        self.name = name
        self.type = type
        self.description = description
        self.ingredients = ingredients
        self.ingredientsCount = ingredientsCount
        self.id = id
    }
}

