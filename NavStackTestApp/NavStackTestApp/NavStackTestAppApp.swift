//
//  NavStackTestAppApp.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/1/22.
//

import SwiftUI

@main
struct NavStackTestAppApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(recipes: recipesList)
        }
    }
}
