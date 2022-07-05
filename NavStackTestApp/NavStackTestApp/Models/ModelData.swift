//
//  ModelData.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/2/22.
//

import Foundation

var ingredientsList: [Ingredient] = load("Sample_Ingredients.json")
var recipesList: [Recipe] = load("Sample_Recipes.json")

func load<T: Decodable>(_ fileName: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil)
    else {
        fatalError("Couldn't find \(fileName)")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Something went wrong")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("\(error)")
    }
}
